const { SNSClient, PublishCommand } = require("@aws-sdk/client-sns");
const snsClient = new SNSClient({});

exports.handler = async (event) => {
    console.log("Evento completo recibido: ", JSON.stringify(event, null, 2));

    try {
        let body = {};
        if (event.body) {
            try {
                // Determine if event.body is already an object or needs parsing
                body = typeof event.body === 'string' ? JSON.parse(event.body) : event.body;

                if (event.isBase64Encoded && typeof event.body === 'string') {
                    const decoded = Buffer.from(event.body, 'base64').toString('utf8');
                    body = JSON.parse(decoded);
                }
            } catch (e) {
                console.warn("No se pudo parsear event.body, usando como objeto", e);
                body = typeof event.body === 'object' ? event.body : {};
            }
        } else {
            // Sometimes in other API GW configurations it comes direct
            body = event;
        }

        const { name, email, message } = body;

        if (!name || !email || !message) {
            return {
                statusCode: 400,
                headers: {
                    "Access-Control-Allow-Origin": "*",
                    "Access-Control-Allow-Headers": "Content-Type",
                    "Access-Control-Allow-Methods": "OPTIONS,POST"
                },
                body: JSON.stringify({ message: "Faltan campos obligatorios." })
            };
        }

        const snsMessage = `Recibiste un nuevo mensaje de contacto en tu Portafolio:\n\nNombre: ${name}\nEmail: ${email}\n\nMensaje:\n${message}`;

        const params = {
            Message: snsMessage,
            Subject: `Portafolio AWS - Mensaje de: ${name}`,
            TopicArn: process.env.SNS_TOPIC_ARN
        };

        const command = new PublishCommand(params);
        await snsClient.send(command);

        return {
            statusCode: 200,
            headers: {
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Headers": "Content-Type",
                "Access-Control-Allow-Methods": "OPTIONS,POST"
            },
            body: JSON.stringify({ message: "Mensaje enviado exitosamente." })
        };
    } catch (error) {
        console.error("Error enviando mensaje: ", error);
        return {
            statusCode: 500,
            headers: {
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Headers": "Content-Type",
                "Access-Control-Allow-Methods": "OPTIONS,POST"
            },
            body: JSON.stringify({ message: "Ocurrió un error al enviar el mensaje. Inténtalo más tarde." })
        };
    }
};
