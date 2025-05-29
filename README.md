<h1 align="middle"> <img src="https://skillicons.dev/icons?i=kafka" width="35"/> KAFKA BASICS 101 <img src="https://skillicons.dev/icons?i=kafka" width="35" /></h1>

<div align="center">

This repository contains notes and learnings from my Apache Kafka course, broken down into logical blog-style entries.

[![bhaumikmaan - Understanding-Kafka-Basics](https://img.shields.io/static/v1?label=bhaumikmaan&message=Understanding-Kafka-Basics&color=2ea44f&logo=github)](https://github.com/bhaumikmaan/Understanding-Kafka-Basics "Go to GitHub repo")
&nbsp; [![stars - Understanding-Kafka-Basics](https://img.shields.io/github/stars/bhaumikmaan/Understanding-Kafka-Basics?style=social)](https://github.com/bhaumikmaan/Understanding-Kafka-Basics)
&nbsp; [![forks - Understanding-Kafka-Basics](https://img.shields.io/github/forks/bhaumikmaan/Understanding-Kafka-Basics?style=social)](https://github.com/bhaumikmaan/Understanding-Kafka-Basics)
&nbsp; [![License](https://img.shields.io/badge/License-Apache--2.0_license-2ea44f)](#license)
<br/>

<a href="https://medium.com/@bhaumikmaan/kafka-basics-101-dbd7c2d3a740" target="_blank">
  <img src="https://img.shields.io/badge/Read%20Blog%20on-Medium-black?logo=medium&style=for-the-badge" alt="Read Blog on Medium"/>
</a>
&nbsp;
<a href="https://github.com/bhaumikmaan/Understanding-Kafka-Basics/stargazers" target="_blank">
  <img src="https://img.shields.io/badge/Star-This%20Repo-yellow?style=for-the-badge&logo=github" alt="Star this repo"/>
</a>
</div>

<hr style="height:10px">

## Riding the Data Wave: My Journey Through Apache Kafka 🌊

In today's data-driven world, the ability to handle vast streams of information in real-time isn't just a bonus; it's a necessity. I recently completed a course on Apache Kafka, and it was an eye-opening experience into the backbone of many modern data architectures. If you've ever wondered how companies manage massive flows of messages, from website clicks to sensor data, chances are Kafka is working its magic behind the scenes. This blog post is my way of consolidating what I've learned and sharing the core concepts of Kafka that I found most fascinating. Let's dive in!
<br>

![img](https://github.com/user-attachments/assets/8a59a3f4-5c11-43ff-acc8-b62980afc4b2)

<hr style="height:10px">

## The Building Blocks 🧱

Kafka excels at managing high-volume event streams. A core principle is **immutability**: once data is written to Kafka, it doesn't change. This simplifies things and ensures data integrity.

Here are the key components:

* **Topics**: These are named streams of records. Think of them like categories or feeds where related messages are published. For instance, a `website_clicks` topic would hold all click data.
* **Partitions**: Topics are broken down into **partitions**. These are the actual storage units. Dividing topics into partitions allows Kafka to scale and handle data in parallel. Data within a partition is **immutable** and typically stored for a limited time.
* **Offsets**: Messages within each partition are **ordered**. Each message gets an incremental ID called an **offset**. This offset uniquely identifies a message within its partition and defines its sequence (e.g., offset `0` is before offset `1`).
* **Kafka Data Streams**: This term simply refers to the continuous flow of messages through Kafka topics.
* **Producers and Consumers**: You don't query topics directly.
    * **Kafka Producers** are client applications that write/send messages to Kafka topics.
    * **Kafka Consumers** are client applications that read/subscribe to messages from Kafka topics.

Grasping these basics is the first step to understanding Kafka's power in event streaming.

<hr style="height:10px">

## Sending Data: A Closer Look at Kafka Producers 📤

**Kafka Producers** are the workhorses that write your data into Kafka topics. They handle crucial tasks like directing messages to the correct partitions, ensuring data is delivered reliably, and optimizing for performance.

![img_1](https://github.com/user-attachments/assets/22bb066c-ba8d-4f7e-aadf-1fc0b5d08c60)
--- 

### Directing Traffic: How Producers Choose a Partition

Producers need to decide which partition within a topic to send a message. This is often influenced by a **message key**. If no key is provided, messages are typically distributed in a **round-robin** fashion across partitions, helping to spread the load evenly. However, if a message includes a key (like a `userID` or `orderID`), the producer uses hashing to ensure that all messages with the **same key consistently land in the same partition**. This is vital for use cases requiring ordered processing of related events. The underlying logic for this assignment is handled by the **Kafka Partitioner**, which can be customized if needed. Producers are also resilient; if a Kafka broker fails, they will **automatically attempt to recover** and send data to other available brokers in the cluster.

---
### Confirming Delivery: Understanding Acknowledgments (`acks`)

Simply sending a message isn't always enough; producers need confirmation that the data has been safely received. This is controlled by the **`acks`** configuration, which offers different levels of durability guarantees:

* **`acks=0`**: The producer sends the message and doesn't wait for any confirmation. This provides the lowest latency but also the highest risk of data loss if the broker fails immediately after the send.
* **`acks=1`** (Default for Kafka v1.0 - v2.8): The producer waits for an acknowledgment from the partition's leader replica. This confirms the leader has written the message, but data could still be lost if the leader fails before that message is replicated to its followers.
* **`acks=all`** (or `-1`, default for Kafka v3.0+): This offers the strongest guarantee. The producer waits for the leader to confirm that the message has been written and successfully replicated to all in-sync follower replicas, ensuring data safety even if the leader fails.

Choosing the right `acks` setting involves a trade-off between the speed of writes and the assurance of data durability.

---
### Navigating Issues: Retries and Idempotence

In distributed systems, transient errors can occur. Producers are built to handle these:

They will **automatically retry sending messages** if an error occurs. Kafka versions 2.1 and later default to a very high number of retries, though these are bounded by a delivery timeout (typically 2 minutes). While retries enhance reliability, they can, in some scenarios, lead to messages within a batch being delivered out of their original send order.

A more subtle issue is potential data duplication. If a producer sends a message, the broker commits it, but the acknowledgment gets lost, the producer might retry and send the same message again. To prevent this, **idempotent producers** (default since Kafka 3.0) are used. By enabling `enable.idempotence=true`, producers assign sequence numbers to messages, allowing brokers to detect and discard any duplicates from retries. This ensures each message is processed exactly once, and it implicitly sets `acks=all` and a high number of retries.

---
### Optimizing Producer Throughput

Several factors influence how efficiently producers can send data:

First, messages must be converted into **byte arrays** using **serializers**, as Kafka handles data in this format. For better performance, especially with text-based data like JSON, **message compression** at the producer is highly recommended. This reduces data size, leading to faster network transmission, lower latency, and more efficient disk usage.

Producers also improve efficiency by **batching messages** destined for the same partition. Instead of sending messages one by one, they can group them. With "sticky partitioning" (often used when keys aren't specified), a producer will "stick" to one partition for a batch of messages to improve batch size and compression, then switch for the next. Key settings like `linger.ms` (how long to wait for more messages to fill a batch) and `batch.size` (the maximum size of a batch) allow you to fine-tune this behavior.

![img_2](https://github.com/user-attachments/assets/cd19c35e-3343-4157-b072-55a972b002b8)

Finally, producers use an internal buffer (`buffer.memory`) for records awaiting sending. If this buffer fills up because the producer is faster than the broker can handle, subsequent `send()` calls can block for a period defined by `max.block.ms` before an error is thrown.

By understanding and configuring these aspects, you can tailor your Kafka producers for both reliability and high performance.

<hr style="height:10px">

## Receiving Data: Kafka Consumers Explained 📥

**Kafka Consumers** are applications that read data from Kafka topics. They use a **pull model**, fetching data from brokers, and read messages in order (by offset) within each partition. Consumers need a **deserializer** matching the producer's serializer to interpret messages correctly.

![img_3](https://github.com/user-attachments/assets/f66f2461-fe70-4ccb-afb6-80d4c1147f6f)

---
### Teamwork: Consumer Groups & Parallelism

Consumers typically belong to a **consumer group**. Kafka distributes topic partitions among consumers in a group, so **each partition is handled by only one consumer within that group**. This enables parallel processing. Different consumer groups can independently consume from the same topic.

---
### Tracking Progress: Consumer Offsets

Kafka stores **offsets** for each consumer group, marking the last processed message per partition. Consumers **commit these offsets** periodically. If a consumer fails, it (or a replacement) can resume from the last committed offset, preventing data loss or reprocessing from the beginning.

---
### Message Delivery: Semantics

The timing of offset commits defines message delivery guarantees:

* **At Least Once**: Offsets are committed *after* message processing. If processing fails before a commit, the message might be re-processed. This is common with `enable.auto.commit=true` and requires idempotent processing logic.
* **At Most Once**: Offsets are committed *before* message processing. If processing fails, the message is lost.
* **Exactly Once**: Guarantees each message is processed once, usually involving advanced Kafka features like transactions.

---
### Dynamic Consumption: Rebalancing & Partition Assignment

When consumers join or leave a group, or topic partitions change, a **rebalance** occurs to redistribute partitions.

* **Rebalance Strategies**:
    * **Eager Rebalance**: All consumers stop, and partitions are fully reassigned, causing a consumption pause.
    * **Cooperative Rebalance (Incremental)**: Reassigns a subset of partitions, allowing unaffected consumers to continue, reducing downtime.
* **Partition Assignment Strategies** (`partition.assignment.strategy`): Defines how partitions are allocated (e.g., `RangeAssignor`, `RoundRobinAssignor`, `StickyAssignor`, `CooperativeStickyAssignor`). The default often includes `RangeAssignor` and `CooperativeStickyAssignor`.
* **Static Membership**: Can reduce rebalances for known consumers that temporarily leave, as their partitions aren't immediately reassigned until a timeout.

---
### Consumer Health & Key Configurations

Kafka monitors consumer health:

* **Offset Committing**:
    * `enable.auto.commit=true` (default): Offsets commit automatically (via `auto.commit.interval.ms` or during `poll()`), usually leading to at-least-once.
    * `enable.auto.commit=false`: Application manually commits offsets, offering more control.
* **Liveness**:
    * Consumers send **heartbeats** to the broker (default every 3s). If no heartbeat within `session.timeout.ms` (default 45s), the consumer is considered dead, triggering a rebalance.
* **Polling Behavior**:
    * `max.poll.interval.ms`: Max time between `poll()` calls. Exceeding this deems the consumer failed.
    * `max.poll.records`: Max records per `poll()` request, controlling batch processing size.


<hr style="height:10px">

## The Backbone of the Cluster: Understanding Kafka Brokers 🖥️

At the core of any Apache Kafka deployment is the **Kafka cluster**, a group of one or more servers, each called a **Kafka broker**. These brokers are fundamental to Kafka's operation, handling message reception, storage, and delivery.

* **Bootstrap Servers**: Your applications connect to the Kafka cluster by initially contacting one or more of these brokers, known as bootstrap servers.
* **Cluster Discovery**: Once connected to a bootstrap broker, clients automatically discover all other brokers, topics, and partitions, as each broker holds metadata about the entire cluster.

![img_4](https://github.com/user-attachments/assets/d8e94432-9ab0-4d33-b1be-2aea4dc752fc)

Brokers are responsible for hosting the **partitions** of your topics. For each partition, the cluster designates one broker as the **leader**.

* **Partition Leader**: This is the *only* broker to which producers can send data for a specific partition.
* **Followers**: Other brokers holding copies of the partition's data are called followers.

To ensure data durability and high availability, Kafka employs **replication**.

* **Replication Factor**: This setting defines how many copies (replicas) of a topic's partition are maintained across different brokers. For example, a replication factor of 3 means one leader and two followers.
* **Data Redundancy**: Followers continuously replicate data from their partition's leader. If a leader broker fails, a follower is elected as the new leader, ensuring data remains available.

<hr style="height:10px">

## Broker Management & Critical Configurations ⚙️

Beyond their core message handling, Kafka brokers require coordination and careful configuration for optimal performance and resilience. Historically, this coordination has been the job of Apache Zookeeper, but this is evolving.

### Zookeeper's Role and the Rise of KRaft

**Apache Zookeeper** has traditionally played a crucial part in managing Kafka clusters.

* It keeps track of which brokers are active in the cluster.
* It sends notifications to Kafka clients and brokers about any changes, such as brokers joining or leaving the cluster, or topics being created or deleted.
* Crucially, Zookeeper performs **leader elections** for partitions, deciding which broker replica will be the leader if an existing leader fails.

However, the dependency on Zookeeper is changing:

* Kafka **2.x versions require Zookeeper** to function.
* Starting with Kafka **3.x, clusters can run in KRaft (Kafka Raft) mode**, which allows Kafka to operate **without Zookeeper**.
* The plan is for Kafka **4.x to completely remove Zookeeper** dependency.

**KRaft** (Kafka Raft Consensus Protocol) is Kafka's own consensus mechanism designed to replace Zookeeper.

* It addresses **scaling limitations** observed with Zookeeper, particularly in very large clusters (e.g., those with over 100,000 partitions).
* In KRaft mode, a subset of brokers, designated as controllers, form a **quorum**. One of these controller brokers is elected as the **quorum leader**, taking over the cluster metadata management responsibilities previously handled by Zookeeper.

---
### Choosing the Right Values: Partitions and Replication Factor

Two of the most critical decisions when designing your Kafka topics are determining the number of partitions and the replication factor.

**Partitions**:
The number of partitions for a topic impacts its parallelism and throughput.

* **More partitions can lead to**:
    * Better parallelism, as more consumers in a group can read concurrently.
    * Higher overall throughput for the topic.
    * Ability to leverage more brokers in the cluster.
* **However, consider**:
    * Each partition corresponds to open file handles on the Kafka brokers.
    * A very large number of partitions can increase the time for leader elections, especially in Zookeeper-based clusters.

**Replication Factor (RF)**:
This determines how many copies of your data are stored across the cluster.

* **Recommendations**:
    * A replication factor of **at least 2** is generally advised for production to avoid data loss if one broker fails.
    * **A common value is 3**, providing a good balance between durability and resource usage.
    * A maximum of **4 is often sufficient** for most high-availability needs.
* **Impact**:
    * **Higher RF**: Improves data durability and availability (the topic can tolerate more broker failures).
    * **Trade-offs**: Leads to increased network traffic for replication and consumes more disk space across the cluster.

<hr style="height:10px">

## Beyond Basic Piping: Kafka Streams and Schema Management 🌊

While Kafka producers and consumers are powerful for getting data into and out of Kafka, many use cases require processing or transforming this data in real-time as it flows through the topics. This is where **Kafka Streams** comes in.

**Kafka Streams** is a client library, not a separate cluster, that allows you to build sophisticated stream processing applications and microservices directly within your Java or Scala applications.

![img_5](https://github.com/user-attachments/assets/64fcb936-4a17-4206-a1f4-c16a16d575e5)

* **Higher-Level Abstraction**: It provides a more expressive API than the standard producer/consumer clients, designed specifically for data processing tasks like filtering, mapping, aggregating, joining, and windowing event streams.
* **Simplified Processing**: You can define complex data transformation logic that reads from source topics, processes the data, and then writes the results back to other Kafka topics or makes it available for querying.
* **Kafka-Native**: Because it's built on top of Kafka's core components, it integrates seamlessly and leverages Kafka's scalability and fault tolerance.

---
### Ensuring Data Integrity: The Kafka Schema Registry

When you're processing streams of data, especially as applications evolve, it's crucial to ensure that the structure (or "schema") of your data is consistent and understood by all components. This is where a **Kafka Schema Registry** becomes invaluable.

The Schema Registry is a centralized service that manages your data schemas (e.g., Avro, JSON Schema, Protobuf). It acts as a contract for the data format, ensuring that producers and consumers agree on the structure of messages.

* **Data Validation**: It ensures that data produced to a topic adheres to a predefined schema, rejecting non-compliant "bad data" before it can cause issues downstream.
* **Producer & Consumer Interaction**: Both producers and consumers communicate with the Schema Registry.
    * Producers register schemas and then, when sending messages, often include only a schema ID with the message, reducing payload size.
    * Consumers use this ID to fetch the schema from the registry to correctly deserialize the message.
* **Schema Evolution**: A key feature is support for **schema evolution**. As your data requirements change (e.g., adding a new field), the Schema Registry helps manage these changes with compatibility rules (like backward or forward compatibility), ensuring that new producers can still work with older consumers, or vice versa, without breaking the data pipeline.
* **Lightweight Design**: While powerful, schema registries are designed to be efficient and not impose significant overhead on your Kafka infrastructure.

By using Kafka Streams for processing and a Schema Registry for governance, you can build robust, adaptable, and reliable real-time data pipelines.

<hr style="height:10px">

## Getting Hands-On: Kafka CLI Commands ⌨️

Now that we've covered a lot of Kafka theory, it's time to roll up our sleeves and interact with Kafka directly using its powerful Command Line Interface (CLI) tools. These tools are invaluable for developers and administrators for managing topics, producing/consuming messages for testing, and inspecting the state of the cluster.

> **A Quick Note on Paths**: The Kafka CLI tools are scripts (usually ending in `.sh`) located in the `bin/` directory of your Kafka installation. Your exact path to these scripts might vary. For example, you might use `kafka-topics.sh` or, if your `bin` directory is in your system's PATH, just `kafka-topics`. The examples below use `kafka-topics`, `kafka-console-producer`, etc., assuming these scripts are accessible in your PATH. Adjust as per your environment.

You can find all the commands in the [CLI Directory](https://github.com/bhaumikmaan/Understanding-Kafka-Basics/tree/main/cli)

<hr style="height:10px">

## Advanced Kafka Insights & Further Learning ✨

Beyond the everyday operations, Kafka has a rich set of configurations and internal mechanisms that allow for fine-tuning, specialized use cases, and deeper understanding of its behavior.

---

### Advanced Topic Configurations with `kafka-configs`

While many common topic settings like partition count and replication factor are set during creation with `kafka-topics`, Kafka offers a wide array of other dynamic configurations that can be applied per topic. The `kafka-configs` CLI tool is used for this.

* You can describe existing configurations or alter them.
* This allows you to override broker-level defaults for specific topics.

Other configurations you might manage include `retention.ms`, `cleanup.policy`, `segment.bytes`, etc.

---
### Understanding Log Segments

We know topics are divided into partitions. But how is data stored within a partition on a broker's disk? Partitions are actually made up of **log segments**, which are individual files.

* **Appending Data**: Data is always appended to the *active segment* file for a partition.
* **Segment Rolling**: Once a segment reaches a certain size or age, it's closed, and a new active segment is created. This is controlled by:
    * `log.segment.bytes`: The maximum size (in bytes) of a single segment file before it's closed (e.g., 1GB).
    * `log.roll.ms` (or `log.roll.hours`): The maximum time a segment remains open before being rolled, even if it hasn't reached its size limit.
* **Indices**: Each segment has associated index files (one for offsets, another for timestamps) that help Kafka quickly locate messages within that segment.

This segmentation strategy helps with efficient data management, cleanup, and indexing.

---
### Log Compaction: Keeping a Snapshot

By default, Kafka retains data in topics for a configured period (e.g., 7 days, based on `retention.ms`) or size (`retention.bytes`). However, for some use cases, you might only care about the *latest value for each message key*. This is where **log compaction** comes in.

* **How it Works**: For a compacted topic, Kafka ensures that it retains at least the last known value for each unique message key within a partition. Older messages with the same key are eventually cleaned up.
* **Use Cases**:
    * Maintaining a snapshot of state (e.g., the latest user profile update, current product inventory).
    * Change data capture (CDC) streams.
* **Key Points**:
    * Message order is still guaranteed for new messages (when tailing the log).
    * Compaction happens in the background on closed segments.
    * Messages with `null` values are treated as "tombstones" and can lead to the deletion of all previous messages for that key.
* **Further Reading**: For a detailed explanation, check out Conduktor's article: [Kafka Topic Configuration: Log Compaction](https://learn.conduktor.io/kafka/kafka-topic-configuration-log-compaction/)

To enable compaction, you set the topic's `cleanup.policy` to `compact`. You might also configure it with `delete` (e.g., `cleanup.policy=compact,delete`) to both compact and eventually delete old data based on retention time if needed.

---
### Handling Large Messages in Kafka

Kafka is optimized for relatively small messages. The default maximum message size (controlled by `message.max.bytes` on the broker and `max.request.size` on the producer) is typically **1MB**. Sending messages significantly larger than this can strain broker resources and impact performance.

If you need to handle large data objects:

1.  **Store Externally, Send a Reference**: This is the most common and recommended approach.
    * Upload the large file/object to an external storage system (e.g., S3, HDFS, a database).
    * Send a message to Kafka containing only a *reference* (like a URL or an ID) to this external object.
    * Consumers then use this reference to fetch the large object directly from the external store.
2.  **Change Kafka Configurations (with caution)**: You *can* increase Kafka's limits for message size. This involves several settings on brokers, topics, producers, and consumers:
    * Broker: `message.max.bytes`, `replica.fetch.max.bytes`.
    * Topic: `max.message.bytes` (can override broker default).
    * Producer: `max.request.size`.
    * Consumer: `fetch.message.max.bytes`.
    * **Warning**: Significantly increasing these values can lead to performance issues, increased memory usage on brokers and clients, and longer GC pauses. It should be done carefully and with thorough testing.

---

## Important Links & Further Learning 📚

Here are some valuable resources mentioned, which can help you dive deeper into specific Kafka topics and see it in action:

* **Topic Naming Conventions**: A practical guide on how to choose meaningful and consistent topic names: [How to paint the bike shed - Kafka Topic Naming Conventions](https://cnr.sh/posts/2017-08-29-how-paint-bike-shed-kafka-topic-naming-conventions/)
* **Kafka Monitoring**: Official documentation on metrics and approaches for monitoring your Kafka cluster: [Apache Kafka Documentation - Monitoring](https://kafka.apache.org/documentation/#monitoring)
* **Real-time Data Streams (Examples)**:
    * Wikimedia Recent Changes Stream: [Wikimedia EventStreams](https://stream.wikimedia.org/v2/stream/recentchange)
    * Wikimedia EventSource Demo 1: [Codepen Demo](https://codepen.io/Krinkle/pen/BwEKgW?editors=1010)
    * Wikimedia EventSource Demo 2: [GitHub Demo](https://esjewett.github.io/wm-eventsource-demo/)
* **OpenSearch Quickstart**: If you're looking to integrate Kafka with OpenSearch for analytics: [OpenSearch Docker Quickstart](https://docs.opensearch.org/docs/latest/#docker-quickstart)
* **Kafka Connectors**: Explore pre-built connectors for integrating Kafka with various other systems: [Confluent Hub - Kafka Connectors](https://www.confluent.io/product/connectors/)
