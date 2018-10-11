import '../css/app.css'
import 'phoenix_html'
import socket from './socket'

import html from 'choo/html'
import devtools from 'choo-devtools'
import choo from 'choo'

var app = choo()
app.use(devtools())
app.use(store)
app.route('*', view)
app.mount('#app')

function store (state, emitter) {
  console.debug('Connecting...')

  state.me = null
  state.nodes = []

  emitter.on('socket:error', clearNodes)
  emitter.on('socket:close', () => {
    clearNodes()
    state.me = null
  })
  emitter.on('nodes:error', clearNodes)

  emitter.on('nodes:join', ({ me, nodes }) => {
    state.me = me
    state.nodes = nodes
    emitter.emit('render')
  })

  emitter.on('nodes:refresh', nodes => {
    state.nodes = nodes
    emitter.emit('render')
  })

  function clearNodes () {
    state.nodes = []
    emitter.emit('render')
  }

  socket.onError(() => { emitter.emit('socket:error') })
  socket.onClose(() => { emitter.emit('socket:close') })

  let channel = socket.channel('nodes:all', {})

  channel.join()
    .receive('ok', resp => { emitter.emit('nodes:join', resp) })
    .receive('error', resp => { emitter.emit('nodes:error', resp) })

  channel.on('refresh', msg => {
    if (state.me === msg.me) {
      emitter.emit('nodes:refresh', msg.nodes)
    } else {
      console.debug('discarding', msg)
    }
  })

  emitter.on('refreshNodes', () => {
    channel.push('refresh')
      .receive('ok', msg => { emitter.emit('nodes:refresh', msg) })
      .receive('error', msg => { emitter.emit('nodes:error', msg) })
      .receive('timeout', () => { emitter.emit('nodes:timeout') })
  })

  window.refreshNodes = () => { emitter.emit('refreshNodes') }
}

function view (state, emit) {
  return html`
    <div>
      <h1>${state.me}</h1>
      <ul>
        ${state.nodes.map(node => nodeView(node, emit))}
      </ul>
    </div>
  `
}

function nodeView (node, emit) {
  return html`
    <li>
      ${node}
    </li>
  `
}
