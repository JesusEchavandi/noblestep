using System.Net;
using System.Net.Mail;

namespace NobleStep.Api.Services;

public interface IEmailService
{
    Task SendPasswordResetEmailAsync(string toEmail, string resetToken, string customerName);
    Task SendOrderConfirmationEmailAsync(string toEmail, string orderNumber, string customerName);
}

public class EmailService : IEmailService
{
    private readonly IConfiguration _configuration;
    private readonly ILogger<EmailService> _logger;

    public EmailService(IConfiguration configuration, ILogger<EmailService> logger)
    {
        _configuration = configuration;
        _logger = logger;
    }

    public async Task SendPasswordResetEmailAsync(string toEmail, string resetToken, string customerName)
    {
        try
        {
            var fromEmail = _configuration["Email:FromEmail"] ?? "noblestep@gmail.com";
            var fromName = _configuration["Email:FromName"] ?? "NobleStep Shop";
            var smtpHost = _configuration["Email:SmtpHost"] ?? "smtp.gmail.com";
            var smtpPort = int.Parse(_configuration["Email:SmtpPort"] ?? "587");
            var smtpUsername = _configuration["Email:SmtpUsername"] ?? fromEmail;
            var smtpPassword = _configuration["Email:SmtpPassword"] ?? "";
            
            var resetLink = $"{_configuration["App:FrontendUrl"]}/reset-password?token={resetToken}";

            var subject = "Restablecer tu contraseña - NobleStep";
            var body = $@"
                <html>
                <head>
                    <style>
                        body {{ font-family: Arial, sans-serif; line-height: 1.6; color: #333; }}
                        .container {{ max-width: 600px; margin: 0 auto; padding: 20px; }}
                        .header {{ background-color: #2563eb; color: white; padding: 20px; text-align: center; }}
                        .content {{ padding: 20px; background-color: #f9f9f9; }}
                        .button {{ display: inline-block; padding: 12px 24px; background-color: #2563eb; color: white; text-decoration: none; border-radius: 5px; margin: 20px 0; }}
                        .footer {{ padding: 20px; text-align: center; font-size: 12px; color: #666; }}
                    </style>
                </head>
                <body>
                    <div class='container'>
                        <div class='header'>
                            <h1>NobleStep Shop</h1>
                        </div>
                        <div class='content'>
                            <h2>Hola {customerName},</h2>
                            <p>Recibimos una solicitud para restablecer tu contraseña.</p>
                            <p>Haz clic en el siguiente botón para crear una nueva contraseña:</p>
                            <div style='text-align: center;'>
                                <a href='{resetLink}' class='button'>Restablecer Contraseña</a>
                            </div>
                            <p>O copia y pega este enlace en tu navegador:</p>
                            <p style='word-break: break-all; color: #2563eb;'>{resetLink}</p>
                            <p><strong>Este enlace expirará en 1 hora.</strong></p>
                            <p>Si no solicitaste restablecer tu contraseña, puedes ignorar este correo.</p>
                        </div>
                        <div class='footer'>
                            <p>&copy; 2025 NobleStep. Todos los derechos reservados.</p>
                        </div>
                    </div>
                </body>
                </html>
            ";

            await SendEmailAsync(fromEmail, fromName, toEmail, subject, body, smtpHost, smtpPort, smtpUsername, smtpPassword);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error enviando email de recuperación de contraseña a {Email}", toEmail);
            throw;
        }
    }

    public async Task SendOrderConfirmationEmailAsync(string toEmail, string orderNumber, string customerName)
    {
        try
        {
            var fromEmail = _configuration["Email:FromEmail"] ?? "noblestep@gmail.com";
            var fromName = _configuration["Email:FromName"] ?? "NobleStep Shop";
            var smtpHost = _configuration["Email:SmtpHost"] ?? "smtp.gmail.com";
            var smtpPort = int.Parse(_configuration["Email:SmtpPort"] ?? "587");
            var smtpUsername = _configuration["Email:SmtpUsername"] ?? fromEmail;
            var smtpPassword = _configuration["Email:SmtpPassword"] ?? "";

            var subject = $"Confirmación de Pedido #{orderNumber} - NobleStep";
            var body = $@"
                <html>
                <head>
                    <style>
                        body {{ font-family: Arial, sans-serif; line-height: 1.6; color: #333; }}
                        .container {{ max-width: 600px; margin: 0 auto; padding: 20px; }}
                        .header {{ background-color: #2563eb; color: white; padding: 20px; text-align: center; }}
                        .content {{ padding: 20px; background-color: #f9f9f9; }}
                        .order-box {{ background-color: white; padding: 15px; margin: 15px 0; border-left: 4px solid #2563eb; }}
                        .footer {{ padding: 20px; text-align: center; font-size: 12px; color: #666; }}
                    </style>
                </head>
                <body>
                    <div class='container'>
                        <div class='header'>
                            <h1>NobleStep Shop</h1>
                        </div>
                        <div class='content'>
                            <h2>¡Gracias por tu compra, {customerName}!</h2>
                            <p>Tu pedido ha sido recibido exitosamente.</p>
                            <div class='order-box'>
                                <h3>Número de Pedido: #{orderNumber}</h3>
                                <p>Estamos procesando tu pedido y te enviaremos actualizaciones por correo electrónico.</p>
                            </div>
                            <p>Puedes ver el estado de tu pedido en tu panel de usuario en nuestro sitio web.</p>
                            <p>Si tienes alguna pregunta, no dudes en contactarnos.</p>
                        </div>
                        <div class='footer'>
                            <p>&copy; 2025 NobleStep. Todos los derechos reservados.</p>
                        </div>
                    </div>
                </body>
                </html>
            ";

            await SendEmailAsync(fromEmail, fromName, toEmail, subject, body, smtpHost, smtpPort, smtpUsername, smtpPassword);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error enviando email de confirmación de pedido a {Email}", toEmail);
            // No lanzar excepción para no bloquear la creación del pedido
        }
    }

    private async Task SendEmailAsync(string fromEmail, string fromName, string toEmail, string subject, string body, 
        string smtpHost, int smtpPort, string smtpUsername, string smtpPassword)
    {
        using var message = new MailMessage();
        message.From = new MailAddress(fromEmail, fromName);
        message.To.Add(new MailAddress(toEmail));
        message.Subject = subject;
        message.Body = body;
        message.IsBodyHtml = true;

        using var smtpClient = new SmtpClient(smtpHost, smtpPort);
        smtpClient.Credentials = new NetworkCredential(smtpUsername, smtpPassword);
        smtpClient.EnableSsl = true;

        await smtpClient.SendMailAsync(message);
        _logger.LogInformation("Email enviado exitosamente a {Email}", toEmail);
    }
}
