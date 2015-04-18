# Password for cloud-config at Digital Ocean... https://coreos.com/docs/running-coreos/cloud-providers/digitalocean/
# bad idea: mkpasswd --method=SHA-512 --rounds=4096

root == core <%D

### SHORT https://coreos.com/etcd/docs/0.4.7/etcd-api/
## Start:
./bin/etcd -data-dir machine0 -name machine0

curl -L http://127.0.0.1:4001/version

## Create value
curl -L http://127.0.0.1:4001/v2/keys/message -XPUT -d value="Hello world"

# etcd includes a few HTTP headers in responses that provide global
# information about the etcd cluster that serviced a request:
# X-Etcd-Index is the current etcd index as explained above.
# X-Raft-Index is similar to the etcd index but is for the underlying raft
# X-Raft-Term is an integer that will increase whenever an etcd master
#   election happens in the cluster. If this number is increasing rapidly,
#   you may need to tune the election timeout. See the tuning section
#   for details.

## Get value
curl -L http://127.0.0.1:4001/v2/keys/message

## Changing the value of a key
curl -L http://127.0.0.1:4001/v2/keys/message -XPUT -d value="Hello etcd"
{
    "action": "set",
    "node": {
        "createdIndex": 3,
        "key": "/message",
        "modifiedIndex": 3,
        "value": "Hello etcd"
    },
    "prevNode": {
        "createdIndex": 2,
        "key": "/message",
        "value": "Hello world",
        "modifiedIndex": 2
    }
}
# The prevNode field represents what the state of a given node was before
# resolving the request at hand.

## Deleting a key
curl -L http://127.0.0.1:4001/v2/keys/message -XDELETE

## Using key TTL
curl -L http://127.0.0.1:4001/v2/keys/foo -XPUT -d value=bar -d ttl=5
# + 2 field in response: ttl, expiration="Very long date format"

# NOTE: Keys can only be expired by a cluster leader, so if a machine gets
# disconnected from the cluster, its keys will not expire until it rejoins.

# The TTL could be unset to avoid expiration through update operation:
curl -L http://127.0.0.1:4001/v2/keys/foo -XPUT -d value=bar -d ttl= -d prevExist=true

## Waiting for a change
# We can watch for a change on a key and receive a notification by using long
# polling. This also works for child keys by passing recursive=true in curl.

## Look in past
# Let's try to watch for the set command of index 7 again:
curl -L 'http://127.0.0.1:4001/v2/keys/foo?wait=true&waitIndex=7'

## Atomically Creating In-Order Keys
curl http://127.0.0.1:4001/v2/keys/queue -XPOST -d value=Job1
curl http://127.0.0.1:4001/v2/keys/queue -XPOST -d value=Job1

# To enumerate the in-order keys as a sorted list, use the "sorted" parameter.
curl -s 'http://127.0.0.1:4001/v2/keys/queue?recursive=true&sorted=true'

## Using a directory TTL
# Like keys, directories in etcd can be set to expire after a specified
# number of seconds. You can do this by setting a TTL (time to live)
# on a directory when it is created with a PUT:
curl -L http://127.0.0.1:4001/v2/keys/dir -XPUT -d ttl=30 -d dir=true

# The directory's TTL can be refreshed by making an update. You can do 
# this by making a PUT with prevExist=true and a new TTL.
curl -L http://127.0.0.1:4001/v2/keys/dir -XPUT -d ttl=30 -d dir=true -d prevExist=true

# Keys that are under this directory work as usual, but when the directory expires,
# a watcher on a key under the directory will get an expire event:
curl 'http://127.0.0.1:4001/v2/keys/dir/asdf?consistent=true&wait=true'

## Atomic Compare-and-Swap