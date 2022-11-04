package camelinaction;

import org.apache.camel.CamelContext;
import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.impl.DefaultCamelContext;

import org.apache.camel.component.amqp.AMQPComponent;

public class BeatsToAMQWithoutTransform {

    public static void main(String args[]) throws Exception {
        // create CamelContext
        CamelContext context = new DefaultCamelContext();

        AMQPComponent amqp = AMQPComponent.amqpComponent("amqp://localhost:5672");
        context.addComponent("amqp", amqp);

        // add our route to the CamelContext
        context.addRoutes(new RouteBuilder() {
            public void configure() {
                from("lumberjack:0.0.0.0").
                convertBodyTo(String.class).
                to("amqp:destinationName?testConnectionOnStartup=true");
//                from("file:data/inbox?noop=true").to("file:data/outbox");
            }
        });

        // start the route and let it do its work
        context.start();
        Thread.sleep(60000);

        // stop the CamelContext
        context.stop();
    }

}
