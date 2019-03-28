#!/bin/bash

EXCHANGE=test_exchange

# create balancer_queue
echo "Creating balancer queue"
rabbitmqadmin declare queue name=balancer_queue

# create worker queues
echo "Creating worker queues"
rabbitmqadmin declare queue name=worker1
rabbitmqadmin declare queue name=worker2
rabbitmqadmin declare queue name=worker3

# create exchange
echo "Creating exchange"
rabbitmqadmin declare exchange name="$EXCHANGE" type=topic

# create bindings
echo "Creating bindings"
rabbitmqadmin declare binding source="$EXCHANGE" destination=worker1 routing_key=w1
rabbitmqadmin declare binding source="$EXCHANGE" destination=worker2 routing_key=w2
rabbitmqadmin declare binding source="$EXCHANGE" destination=worker3 routing_key=w3

# fire messages to balancer_queue
echo "Sending messages to balancer_queue"

i=0
x=1
while [[ "$i" -lt 20 ]]; do
  echo "{\"id\": w$x}" | rabbitmqadmin publish exchange=amq.default routing_key=hello_queue
  i=$((i+1))
  x=$((x+1))
  if [[ "$x" == 4 ]]; then
    x=1
  fi
done

echo "DONE!"

