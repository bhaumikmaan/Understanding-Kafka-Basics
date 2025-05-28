# Describe all dynamic configurations for a topic named 'configured-topic'
# (Note: Ensure your bootstrap server address and port are correct, e.g., localhost:9092)
kafka-configs --bootstrap-server localhost:9092 --entity-type topics --entity-name configured-topic --describe

# Alter a topic's configuration: Add/update min.insync.replicas for 'configured-topic'
# This requires at least 2 replicas to be in sync for a producer with acks=all to succeed.
kafka-configs --bootstrap-server localhost:9092 --entity-type topics --entity-name configured-topic --alter --add-config min.insync.replicas=2