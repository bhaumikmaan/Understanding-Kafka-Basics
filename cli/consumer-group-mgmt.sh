# List all consumer groups
kafka-consumer-groups --bootstrap-server localhost:9092 --list

# Describe a specific consumer group to see its members, assigned partitions, and lag
kafka-consumer-groups --bootstrap-server localhost:9092 --describe --group my-first-application
# The 'CURRENT-OFFSET' is the last committed offset for a partition.
# The 'LOG-END-OFFSET' is the offset of the latest message in the partition.
# 'LAG' is the difference (LOG-END-OFFSET - CURRENT-OFFSET), indicating how many messages the group is behind.

# If you run a console consumer, it creates a group often named like 'console-consumer-XXXXX'.
# You can find its name using --list and then describe it.
kafka-console-consumer --bootstrap-server localhost:9092 --topic third_topic --group my-test-group
kafka-consumer-groups --bootstrap-server localhost:9092 --describe --group my-test-group