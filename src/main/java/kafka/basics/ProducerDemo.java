package kafka.basics;

import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.apache.kafka.common.serialization.StringSerializer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Properties;

public class ProducerDemo {

    private static final Logger log = LoggerFactory.getLogger(ProducerDemo.class.getSimpleName());

    public static void main(String[] args) {
        log.info("I am a Kafka Producer!");

        // create Producer Properties
        Properties properties = new Properties();
        log.info("Setting properties");

        // connect to Localhost : Not secure
        properties.setProperty("bootstrap.servers", "127.0.0.1:9092");

        // connect to Conduktor Playground : Change to your config
//        properties.setProperty("bootstrap.servers", "cluster.playground.cdkt.io:9092");
//        properties.setProperty("security.protocol", "SASL_SSL");
//        properties.setProperty("sasl.jaas.config", "org.apache.kafka.common.security.plain.PlainLoginModule required username=\"your-username\" password=\"your-password\";");
//        properties.setProperty("sasl.mechanism", "PLAIN");

        // set producer properties : Kafka expects string input so it is serialized
        properties.setProperty("key.serializer", StringSerializer.class.getName());
        properties.setProperty("value.serializer", StringSerializer.class.getName());

        log.info("Creating a Kafka Producer!");
        // create the Producer
        KafkaProducer<String, String> producer = new KafkaProducer<>(properties);

        log.info("Writing in the Kafka Producer!");
        // create a Producer Record : Multiple parameters in the constructor - see all
        ProducerRecord<String, String> producerRecord =
                new ProducerRecord<>("demo_java", "hello world");

        // send data : it flushes by default but can be done explicitly as well
        producer.send(producerRecord);

        // tell the producer to send all data and block until done - synchronous
        producer.flush();

        // flush and close the producer
        producer.close();

        // Verify by checking the consumer
        // kafka-console-consumer --bootstrap-server localhost:9092 --topic demo_java --from-beginning
    }
}