package util;

import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class MailSender {
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final int SMTP_PORT = 587;
    private static final String SMTP_USER = "vienpdhe171323@fpt.edu.vn";
    private static final String SMTP_PASS = "nlhftrtahmnaklxc"; // dùng App Password

    private static final String FROM_NAME = "Online Market";

    public static void send(String to, String subject, String htmlContent) throws MessagingException {
        Properties props = new Properties();
        props.put("mail.transport.protocol", "smtp");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", String.valueOf(SMTP_PORT));

        Session session = Session.getInstance(props, new Authenticator() {
            @Override protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SMTP_USER, SMTP_PASS);
            }
        });

        MimeMessage msg = new MimeMessage(session);
        try {
            msg.setFrom(new InternetAddress(SMTP_USER, FROM_NAME, "UTF-8"));
        } catch (Exception e) {
            msg.setFrom(new InternetAddress(SMTP_USER));
        }
        msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to, false));
        msg.setSubject(subject, "UTF-8");
        msg.setContent(htmlContent, "text/html; charset=UTF-8");

        Transport.send(msg);
    }
}
