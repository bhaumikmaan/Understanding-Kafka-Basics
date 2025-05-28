# First, let's describe our group to see current offsets (assuming it has consumed some messages from 'third_topic')
kafka-consumer-groups --bootstrap-server localhost:9092 --describe --group my-first-application

# Dry Run: Show what the reset operation would do without actually doing it.
# Reset offsets for 'third_topic' for group 'my-first-application' to the earliest available offset.
kafka-consumer-groups --bootstrap-server localhost:9092 --group my-first-application --reset-offsets --to-earliest --topic third_topic --dry-run

# Execute the reset operation:
kafka-consumer-groups --bootstrap-server localhost:9092 --group my-first-application --reset-offsets --to-earliest --topic third_topic --execute

# Describe the group again to see the new offsets (should be at the beginning)
kafka-consumer-groups --bootstrap-server localhost:9092 --describe --group my-first-application

# Now, if you start a consumer from this group, it will read messages from the beginning of 'third_topic' again.
kafka-console-consumer --bootstrap-server localhost:9092 --topic third_topic --group my-first-application

# After it consumes some messages, describe the group again to see offsets advancing.
kafka-consumer-groups --bootstrap-server localhost:9092 --describe --group my-first-application