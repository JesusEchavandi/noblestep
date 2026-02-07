import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router, RouterModule, ActivatedRoute } from '@angular/router';
import { EcommerceAuthService } from '../../services/ecommerce-auth.service';
import { NotificationService } from '../../services/notification.service';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterModule],
  template: `
    <div class="auth-container">
      <div class="auth-card">
        <div class="auth-header">
          <h1>{{ isLogin ? 'Iniciar Sesión' : 'Crear Cuenta' }}</h1>
          <p>{{ isLogin ? '¡Bienvenido de vuelta!' : '¡Únete a nosotros!' }}</p>
        </div>

        <form (ngSubmit)="onSubmit()" class="auth-form">
          <!-- Registro: Nombre completo -->
          <div class="form-group" *ngIf="!isLogin">
            <label for="fullName">Nombre Completo</label>
            <input
              type="text"
              id="fullName"
              [(ngModel)]="formData.fullName"
              name="fullName"
              placeholder="Juan Pérez"
              required
            />
          </div>

          <!-- Email -->
          <div class="form-group">
            <label for="email">Correo Electrónico</label>
            <input
              type="email"
              id="email"
              [(ngModel)]="formData.email"
              name="email"
              placeholder="tu@email.com"
              required
            />
          </div>

          <!-- Registro: Teléfono -->
          <div class="form-group" *ngIf="!isLogin">
            <label for="phone">Teléfono (Opcional)</label>
            <input
              type="tel"
              id="phone"
              [(ngModel)]="formData.phone"
              name="phone"
              placeholder="999999999"
            />
          </div>

          <!-- Contraseña -->
          <div class="form-group">
            <label for="password">Contraseña</label>
            <input
              type="password"
              id="password"
              [(ngModel)]="formData.password"
              name="password"
              placeholder="••••••••"
              required
            />
          </div>

          <!-- Confirmar contraseña (solo registro) -->
          <div class="form-group" *ngIf="!isLogin">
            <label for="confirmPassword">Confirmar Contraseña</label>
            <input
              type="password"
              id="confirmPassword"
              [(ngModel)]="confirmPassword"
              name="confirmPassword"
              placeholder="••••••••"
              required
            />
          </div>

          <!-- Olvidé mi contraseña (solo login) -->
          <div class="forgot-password" *ngIf="isLogin">
            <a (click)="showForgotPassword = true" class="link">¿Olvidaste tu contraseña?</a>
          </div>

          <!-- Botón submit -->
          <button type="submit" class="btn-primary" [disabled]="loading">
            {{ loading ? 'Procesando...' : (isLogin ? 'Iniciar Sesión' : 'Crear Cuenta') }}
          </button>

          <!-- Toggle entre login y registro -->
          <div class="auth-toggle">
            <p *ngIf="isLogin">
              ¿No tienes cuenta? 
              <a (click)="toggleMode()" class="link">Regístrate aquí</a>
            </p>
            <p *ngIf="!isLogin">
              ¿Ya tienes cuenta? 
              <a (click)="toggleMode()" class="link">Inicia sesión aquí</a>
            </p>
          </div>

          <!-- Continuar sin cuenta -->
          <div class="guest-option">
            <button type="button" class="btn-secondary" (click)="continueAsGuest()">
              Continuar sin cuenta
            </button>
          </div>
        </form>
      </div>

      <!-- Modal de recuperación de contraseña -->
      <div class="modal" *ngIf="showForgotPassword" (click)="showForgotPassword = false">
        <div class="modal-content" (click)="$event.stopPropagation()">
          <div class="modal-header">
            <h2>Recuperar Contraseña</h2>
            <button class="close-btn" (click)="showForgotPassword = false">&times;</button>
          </div>
          <div class="modal-body">
            <p>Ingresa tu correo electrónico y te enviaremos un enlace para restablecer tu contraseña.</p>
            <div class="form-group">
              <label for="resetEmail">Correo Electrónico</label>
              <input
                type="email"
                id="resetEmail"
                [(ngModel)]="resetEmail"
                placeholder="tu@email.com"
              />
            </div>
          </div>
          <div class="modal-footer">
            <button class="btn-secondary" (click)="showForgotPassword = false">Cancelar</button>
            <button class="btn-primary" (click)="sendResetEmail()" [disabled]="loading">
              {{ loading ? 'Enviando...' : 'Enviar' }}
            </button>
          </div>
        </div>
      </div>
    </div>
  `,
  styles: [`
    .auth-container {
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 2rem;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    }

    .auth-card {
      background: white;
      border-radius: 12px;
      box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
      padding: 3rem;
      max-width: 500px;
      width: 100%;
    }

    .auth-header {
      text-align: center;
      margin-bottom: 2rem;
    }

    .auth-header h1 {
      font-size: 2rem;
      margin-bottom: 0.5rem;
      color: #1f2937;
    }

    .auth-header p {
      color: #6b7280;
    }

    .form-group {
      margin-bottom: 1.5rem;
    }

    .form-group label {
      display: block;
      margin-bottom: 0.5rem;
      font-weight: 500;
      color: #374151;
    }

    .form-group input {
      width: 100%;
      padding: 0.75rem;
      border: 1px solid #d1d5db;
      border-radius: 8px;
      font-size: 1rem;
      transition: border-color 0.3s;
    }

    .form-group input:focus {
      outline: none;
      border-color: #667eea;
    }

    .forgot-password {
      text-align: right;
      margin-bottom: 1.5rem;
    }

    .link {
      color: #667eea;
      cursor: pointer;
      text-decoration: none;
      font-size: 0.9rem;
    }

    .link:hover {
      text-decoration: underline;
    }

    .btn-primary, .btn-secondary {
      width: 100%;
      padding: 0.875rem;
      border: none;
      border-radius: 8px;
      font-size: 1rem;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s;
    }

    .btn-primary {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
    }

    .btn-primary:hover:not(:disabled) {
      transform: translateY(-2px);
      box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
    }

    .btn-primary:disabled {
      opacity: 0.6;
      cursor: not-allowed;
    }

    .btn-secondary {
      background: #f3f4f6;
      color: #374151;
      margin-top: 1rem;
    }

    .btn-secondary:hover {
      background: #e5e7eb;
    }

    .auth-toggle {
      text-align: center;
      margin-top: 1.5rem;
    }

    .guest-option {
      margin-top: 1rem;
      text-align: center;
    }

    /* Modal styles */
    .modal {
      position: fixed;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background: rgba(0, 0, 0, 0.5);
      display: flex;
      align-items: center;
      justify-content: center;
      z-index: 1000;
    }

    .modal-content {
      background: white;
      border-radius: 12px;
      max-width: 500px;
      width: 90%;
      max-height: 90vh;
      overflow-y: auto;
    }

    .modal-header {
      padding: 1.5rem;
      border-bottom: 1px solid #e5e7eb;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    .modal-header h2 {
      margin: 0;
      font-size: 1.5rem;
    }

    .close-btn {
      background: none;
      border: none;
      font-size: 2rem;
      cursor: pointer;
      color: #6b7280;
    }

    .modal-body {
      padding: 1.5rem;
    }

    .modal-footer {
      padding: 1.5rem;
      border-top: 1px solid #e5e7eb;
      display: flex;
      gap: 1rem;
      justify-content: flex-end;
    }

    .modal-footer button {
      width: auto;
      padding: 0.5rem 1.5rem;
    }

    @media (max-width: 640px) {
      .auth-card {
        padding: 2rem 1.5rem;
      }
    }
  `]
})
export class LoginComponent implements OnInit {
  isLogin = true;
  loading = false;
  showForgotPassword = false;
  resetEmail = '';
  confirmPassword = '';
  returnUrl = '/';

  formData = {
    email: '',
    password: '',
    fullName: '',
    phone: ''
  };

  constructor(
    private authService: EcommerceAuthService,
    private notificationService: NotificationService,
    private router: Router,
    private route: ActivatedRoute
  ) {}

  ngOnInit() {
    // Verificar si ya está autenticado
    if (this.authService.isAuthenticated()) {
      this.router.navigate(['/account']);
      return;
    }

    // Obtener URL de retorno
    this.returnUrl = this.route.snapshot.queryParams['returnUrl'] || '/';
  }

  toggleMode() {
    this.isLogin = !this.isLogin;
    this.confirmPassword = '';
  }

  onSubmit() {
    if (this.isLogin) {
      this.login();
    } else {
      this.register();
    }
  }

  login() {
    if (!this.formData.email || !this.formData.password) {
      this.notificationService.warning('Por favor completa todos los campos');
      return;
    }

    this.loading = true;
    this.authService.login({
      email: this.formData.email,
      password: this.formData.password
    }).subscribe({
      next: (response) => {
        this.loading = false;
        this.notificationService.success('¡Bienvenido de vuelta!');
        this.router.navigate([this.returnUrl]);
      },
      error: (error) => {
        this.loading = false;
        this.notificationService.error(error.error?.message || 'Error al iniciar sesión');
      }
    });
  }

  register() {
    if (!this.formData.email || !this.formData.password || !this.formData.fullName) {
      this.notificationService.warning('Por favor completa todos los campos obligatorios');
      return;
    }

    if (this.formData.password.length < 6) {
      this.notificationService.warning('La contraseña debe tener al menos 6 caracteres');
      return;
    }

    if (this.formData.password !== this.confirmPassword) {
      this.notificationService.warning('Las contraseñas no coinciden');
      return;
    }

    this.loading = true;
    this.authService.register({
      email: this.formData.email,
      password: this.formData.password,
      fullName: this.formData.fullName,
      phone: this.formData.phone
    }).subscribe({
      next: (response) => {
        this.loading = false;
        this.notificationService.success('¡Cuenta creada exitosamente!');
        this.router.navigate([this.returnUrl]);
      },
      error: (error) => {
        this.loading = false;
        this.notificationService.error(error.error?.message || 'Error al crear la cuenta');
      }
    });
  }

  sendResetEmail() {
    if (!this.resetEmail) {
      this.notificationService.warning('Por favor ingresa tu correo electrónico');
      return;
    }

    this.loading = true;
    this.authService.forgotPassword(this.resetEmail).subscribe({
      next: (response) => {
        this.loading = false;
        this.showForgotPassword = false;
        this.notificationService.success('Revisa tu correo electrónico para restablecer tu contraseña');
        this.resetEmail = '';
      },
      error: (error) => {
        this.loading = false;
        this.notificationService.error('Error al enviar el correo');
      }
    });
  }

  continueAsGuest() {
    this.router.navigate(['/catalog']);
  }
}
