# First, ensure 'third_topic' exists, e.g., with 3 partitions:
kafka-topics --bootstrap-server localhost:9092 --topic third_topic --create --partitions 3 --replication-factor 1

# Terminal 1: Start a consumer in a group
kafka-console-consumer --bootstrap-server localhost:9092 --topic third_topic --group my-first-application

# Terminal 2: Start a producer and send some messages to 'third_topic'
kafka-console-producer --bootstrap-server localhost:9092 --topic third_topic
> message 1
> message 2
> message 3
> message 4
> message 5
> message 6

# Terminal 3: Start another consumer in the SAME group 'my-first-application'
kafka-console-consumer --bootstrap-server localhost:9092 --topic third_topic --group my-first-application
# You'll see messages being distributed between the two consumers in Terminal 1 and Terminal 3.
# Each partition is consumed by only one consumer instance within the group.

# Terminal 4: Start a consumer in a DIFFERENT group, reading from the beginning
kafka-console-consumer --bootstrap-server localhost:9092 --topic third_topic --group my-second-application --from-beginning
# This group will receive all messages independently of 'my-first-application'.