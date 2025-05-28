# List all Kafka topics
kafka-topics --bootstrap-server localhost:9092 --list

# Create a topic named "first_topic" (defaults to 1 partition if not specified otherwise in broker config)
kafka-topics --bootstrap-server localhost:9092 --topic first_topic --create

# Create a topic with a specific number of partitions
kafka-topics --bootstrap-server localhost:9092 --topic second_topic --create --partitions 5

# Describe the "second_topic" to see its configuration
kafka-topics --bootstrap-server localhost:9092 --topic second_topic --describe

# Attempt to create a topic with replication factor > number of available brokers (will fail on a single-node cluster)
# This command assumes only 1 broker is running.
kafka-topics --bootstrap-server localhost:9092 --topic third_topic --create --partitions 3 --replication-factor 2
# Expected output: Error due to insufficient brokers for replication factor 2

# Create a topic with replication factor 1 (works on a single-node cluster)
kafka-topics --bootstrap-server localhost:9092 --topic third_topic --create --partitions 3 --replication-factor 1
# Describe it to confirm
kafka-topics --bootstrap-server localhost:9092 --topic third_topic --describe

# Delete a topic (requires 'delete.topic.enable=true' in your server.properties)
kafka-topics --bootstrap-server localhost:9092 --topic first_topic --delete