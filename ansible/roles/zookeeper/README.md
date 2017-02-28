# ansible-zookeeper

Ansible playbook for ZooKeeper.

## Installation

```bash
ansible-galaxy install cgswong.ansible-zookeeper
```

## Dependencies

None. Currently, the latest Java 8 is installed as part of the playbook. If you want to lock the version or use a Java playbook to manage feel free.

## Requirements

Ansible version >= 2.1

## Role Variables

```yaml
---
# ZooKeeper version to install
zk_version: "3.4.9"
# URL for ZooKeeper download
zk_url: "http://www.us.apache.org/dist/zookeeper/zookeeper-{{ zk_version }}/zookeeper-{{ zk_version }}.tar.gz"
# OS user to create and use
zk_os_user: "zookeeper"
# OS group to create and use for user
zk_os_group: "zookeeper"
# Base ZooKeeper software installation directory
zk_base_dir: "/opt"
# ZooKeeper software installation directory
zk_dir: "{{ zk_base_dir }}/zookeeper"
# ZooKeeper configuration directory
zk_conf_dir: "/etc/zookeeper"
# ZooKeeper configuration file
zk_conf_file: "zoo.cfg"
# ZooKeeper OS PID (process identifier) directory location
zk_pid_dir: "/var/run/zookeeper"
# ZooKeeper OS PID (process identifier) full file path
zk_pid_file: "{{ zk_pid_dir }}/zookeeper_server.pid"
# Enable to start `zookeeper` service during provisioning
##zk_start_service: true

## Logging ##
# ZooKeeper log directory
zk_log_dir: "/var/log/zookeeper"
# ZooKeeper log file name
zk_log_file: "zookeeper.log"
# ZooKeeper trace directory
zk_trace_dir: "/var/log/zookeeper"
# ZooKeeper trace file name
zk_trace_file: "zookeeper_trace.log"

# ZooKeeper log4j console logging level (INFO | WARN | ERROR | FATAL | TRACE | DEBUG)
zk_console_log_level: "INFO"
# ZooKeeper log4j standard logging level (INFO | WARN | ERROR | FATAL | TRACE | DEBUG)
zk_log_level: "INFO"
# ZooKeeper log4j trace logging level (INFO | WARN | ERROR | FATAL | TRACE | DEBUG)
zk_trace_level: "TRACE"
# ZooKeeper root logger setup where format is `<log level>,<output>` and output should be either `CONSOLE`, or `ROLLINGFILE`
zk_root_logger: "{{ zk_log_level }},ROLLINGFILE"

# Rolling file appender settings where `..._max_size` is the maximum size of the file before rotation
# and `..._max_count` are the number of files to keep
zk_rolling_log_file_max_size: "20MB"
zk_rolling_log_file_max_count: 10

## Settings/Configuration ##
# JMX
# Set to `true` to disable remote JMX log4j management
zk_jmx_log4j_disable: 'false'
# JMX port for remote management
zk_jmx_port: 3181

# Port at which the clients will connect.
zk_clientPort: 2181
# Port at which the clients will connect using SSL (requires Netty connections)
# NOTE: `-Dzookeeper.serverCnxnFactory=org.apache.zookeeper.server.NettyServerCnxnFactory` must be set as a SERVER_JVMFLAGS
zk_secureClientPort: 2281
# The number of ticks that the initial synchronization phase can take.
zk_initLimit: 10
zk_syncLimit: 5
# The number of milliseconds of each tick.
zk_tickTime: 5000
# Maximum number of client connections.
zk_maxClientCnxns: 100
# Set to "0" to disable auto purge feature
zk_autopurge_purgeInterval: 1
# The number of snapshots to retain in dataDir.
zk_autopurge_snapRetainCount: 5
# The directory where the snapshot/data is stored.
zk_dataDir: "/var/lib/zookeeper/data"
# The directory where the transaction logs are stored.
zk_dataLogDir: "/var/lib/zookeeper/logs"

# JVM settings
zk_jvm_min: "512M"
zk_jvm_max: "512M"

# Dictionary of configuration settings to be written into the `zoo.cfg` file
zk_config: {
  "tickTime": "{{ zk_tickTime }}",
  "dataDir": "{{ zk_dataDir }}",
  "dataLogDir": "{{ zk_dataLogDir }}",
  "clientPort": "{{ zk_clientPort }}",
  "secureClientPort": "{{ zk_secureClientPort }}",
  "initLimit": "{{ zk_initLimit }}",
  "syncLimit": "{{ zk_syncLimit }}",
  "maxClientCnxns": "{{ zk_maxClientCnxns }}",
  "autopurge.purgeInterval": "{{ zk_autopurge_purgeInterval }}",
  "autopurge.snapRetainCount": "{{ zk_autopurge_snapRetainCount }}"
}

# Dictionary of environment settings to be written into the (optional) `zookeeper-env.sh` file
zk_env: {
  "JMXLOG4J": "{{ zk_jmx_log4j_disable }}",
  "JMXPORT": "{{ zk_jmx_port }}",
  "ZOOPIDFILE": "{{ zk_pid_file }}",
  "ZOO_LOG_DIR": "{{ zk_log_dir }}",
  "ZOO_LOG4J_PROP": "\"{{ zk_root_logger }}\"",
  "SERVER_JVMFLAGS": "\"-Xms{{ zk_jvm_min }} -Xmx{{ zk_jvm_max }} -Dzookeeper.serverCnxnFactory=org.apache.zookeeper.server.NettyServerCnxnFactory\""
}

## Ensemble members ##
# Dictionary for hosts and myids (i.e. {zk_hosts:[{host:,id:},{host:,id:},...]})
zk_hosts:
  - host: "{{ ansible_hostname }}"
    id: 1
# Custom IP per host group example:
##zk_hosts: "
##  {%- set ips = [] %}
##  {%- for host in groups['zookeepers'] %}
##  {{- ips.append(dict(id=loop.index, host=host, ip=hostvars[host]['ansible_default_ipv4'].address)) }}
##  {%- endfor %}
##  {{- ips -}}"
```

## Example Playbook

```yaml
- name: Installing ZooKeeper
  hosts: all
  become: True
  roles:
    - role: cgswong.ansible-zookeeper
```

## Cluster Example

```yaml
- name: Zookeeper cluster setup
  hosts: zookeepers
  become: True
  roles:
    - role: cgswong.ansible-zookeeper
      zk_hosts: "{{groups['zookeepers']}}"
```

The above assumes the host `zookeepers` is a [hosts group](http://docs.ansible.com/ansible/intro_inventory.html#group-variables) defined in inventory file as shown in the example below:

```inventory
[zookeepers]
server[1:3]
```

### Custom IP per host group example

```
zk_hosts: "
    {%- set ips = [] %}
    {%- for host in groups['zookeepers'] %}
    {{- ips.append(dict(id=loop.index, host=host, ip=hostvars[host]['ansible_default_ipv4'].address)) }}
    {%- endfor %}
    {{- ips -}}"
```

## License

The MIT License (MIT)

Copyright (c) 2014 Stuart Wong

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


## Author Information

@cgswong
