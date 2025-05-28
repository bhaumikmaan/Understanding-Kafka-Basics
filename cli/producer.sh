# Start producing messages to "first_topic". Type messages and press Enter. Use Ctrl+C to exit.
kafka-console-producer --bootstrap-server localhost:9092 --topic first_topic
> Hello World
> My name is Conduktor
> I love Kafka
> ^C

# Produce messages with specific properties, e.g., requiring acks from all replicas
kafka-console-producer --bootstrap-server localhost:9092 --topic first_topic --producer-property acks=all
> some message that is acked
> ^C

# Producing to a non-existing topic:
# If auto.create.topics.enable=true (default is often true) in server.properties, this will create 'new_topic'.
kafka-console-producer --bootstrap-server localhost:9092 --topic new_topic
> hello world!
> ^C

# Check the new topic (it will likely have default partition count from server.properties, or 1)
kafka-topics --bootstrap-server localhost:9092 --describe --topic new_topic

# Tip: It's generally better to explicitly create topics with desired partition/replication settings.
# If you want new auto-created topics to have a different default number of partitions,
# you can edit 'num.partitions' in your config/server.properties (or config/kraft/server.properties)
# and restart the broker. Then try producing to another new topic:
kafka-console-producer --bootstrap-server localhost:9092 --topic new_topic_2
kafka-topics --bootstrap-server localhost:9092 --describe --topic new_topic_2

# Produce messages with keys. Each message is key:value.
# This tells the producer to interpret the input string with a separator for the key.
kafka-console-producer --bootstrap-server localhost:9092 --topic first_topic --property parse.key=true --property key.separator=:
> example_key:example_value
> user_id_123:User clicked a button
> ^C
