This is a fork of `start-stop-daemon(1)` utility shipped with dpkg.

In this fork, user can specify `--isolate` option to isolate the
PID, mount and IPC namespaces of the process on Linux using clone(2)
syscall. If clone syscall isn't supported, isolate option is a no-op.

Note that when isolation is enabled, an additional process is created,
which serves as an init processor in the new PID namespace. This is
required for running forking daemons, as all processes in a namespace
are terminated when an init process exits.
