#!/bin/sh

release_ctl eval --mfa "Example.ReleaseTasks.migrate/1" --argv -- "$@"
