# Ensure 'second_topic' exists, perhaps with multiple partitions
 kafka-topics --bootstrap-server localhost:9092 --topic second_topic --create --partitions 3 --replication-factor 1

# Start consuming messages from "second_topic"
# This will only show messages produced after the consumer starts.
kafka-console-consumer --bootstrap-server localhost:9092 --topic second_topic

# To consume all messages from the beginning of the topic:
kafka-console-consumer --bootstrap-server localhost:9092 --topic second_topic --from-beginning
# Note: If 'second_topic' has multiple partitions, messages from different partitions might appear interleaved,
# but messages within the same partition will always be in order.

# Display key, value, timestamp, and partition for each message:
kafka-console-consumer --bootstrap-server localhost:9092 --topic second_topic --formatter kafka.tools.DefaultMessageFormatter --property print.timestamp=true --property print.key=true --property print.value=true --property print.partition=true --from-beginning