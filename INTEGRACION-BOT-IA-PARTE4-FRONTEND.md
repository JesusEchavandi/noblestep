# 💻 FRONTEND - COMPONENTE DEL CHAT

## PASO 3: Crear Chat Component en Angular

### 3.1 Generar Componente
```bash
cd frontend/src/app
ng generate component chat --standalone
```

### 3.2 chat.service.ts
```typescript
// frontend/src/app/services/chat.service.ts
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface ChatMessage {
  role: 'user' | 'assistant' | 'system';
  content: string;
  timestamp?: Date;
}

export interface ChatRequest {
  message: string;
  history?: ChatMessage[];
}

export interface ChatResponse {
  message: string;
  timestamp: Date;
}

@Injectable({
  providedIn: 'root'
})
export class ChatService {
  private apiUrl = 'http://localhost:5062/api/chat';

  constructor(private http: HttpClient) {}

  sendMessage(message: string, history: ChatMessage[] = []): Observable<ChatResponse> {
    const request: ChatRequest = {
      message,
      history
    };
    return this.http.post<ChatResponse>(`${this.apiUrl}/message`, request);
  }
}
```

### 3.3 chat.component.ts
```typescript
// frontend/src/app/chat/chat.component.ts
import { Component, OnInit, ViewChild, ElementRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ChatService, ChatMessage } from '../services/chat.service';

@Component({
  selector: 'app-chat',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './chat.component.html',
  styleUrls: ['./chat.component.css']
})
export class ChatComponent implements OnInit {
  @ViewChild('messagesContainer') private messagesContainer!: ElementRef;

  messages: ChatMessage[] = [];
  userInput: string = '';
  isLoading: boolean = false;
  isChatOpen: boolean = false;

  constructor(private chatService: ChatService) {}

  ngOnInit() {
    // Mensaje de bienvenida
    this.messages.push({
      role: 'assistant',
      content: '👋 ¡Hola! Soy el asistente virtual de NobleStep. ¿En qué puedo ayudarte hoy?',
      timestamp: new Date()
    });
  }

  toggleChat() {
    this.isChatOpen = !this.isChatOpen;
  }

  sendMessage() {
    if (!this.userInput.trim() || this.isLoading) return;

    // Agregar mensaje del usuario
    const userMessage: ChatMessage = {
      role: 'user',
      content: this.userInput,
      timestamp: new Date()
    };
    this.messages.push(userMessage);

    const messageToSend = this.userInput;
    this.userInput = '';
    this.isLoading = true;

    // Scroll al final
    setTimeout(() => this.scrollToBottom(), 100);

    // Enviar a la API
    this.chatService.sendMessage(messageToSend, this.messages).subscribe({
      next: (response) => {
        this.messages.push({
          role: 'assistant',
          content: response.message,
          timestamp: new Date(response.timestamp)
        });
        this.isLoading = false;
        setTimeout(() => this.scrollToBottom(), 100);
      },
      error: (error) => {
        console.error('Error:', error);
        this.messages.push({
          role: 'assistant',
          content: 'Lo siento, ocurrió un error. Por favor intenta de nuevo.',
          timestamp: new Date()
        });
        this.isLoading = false;
      }
    });
  }

  private scrollToBottom() {
    try {
      this.messagesContainer.nativeElement.scrollTop = 
        this.messagesContainer.nativeElement.scrollHeight;
    } catch(err) {}
  }

  clearChat() {
    this.messages = [{
      role: 'assistant',
      content: '👋 Chat reiniciado. ¿En qué puedo ayudarte?',
      timestamp: new Date()
    }];
  }

  // Sugerencias rápidas
  quickQuestions = [
    '¿Cuánto vendimos hoy?',
    'Mostrar productos con bajo stock',
    'Top 5 productos más vendidos',
    '¿Cómo hago una devolución?'
  ];

  sendQuickQuestion(question: string) {
    this.userInput = question;
    this.sendMessage();
  }
}
```

### 3.4 chat.component.html
```html
<!-- Botón flotante para abrir chat -->
<div class="chat-fab" *ngIf="!isChatOpen" (click)="toggleChat()">
  <i class="bi bi-chat-dots-fill"></i>
  <span class="badge">IA</span>
</div>

<!-- Ventana de chat -->
<div class="chat-window" [class.open]="isChatOpen">
  <!-- Header -->
  <div class="chat-header">
    <div class="chat-title">
      <i class="bi bi-robot"></i>
      <span>Asistente NobleStep</span>
      <span class="status-dot"></span>
    </div>
    <div class="chat-actions">
      <button class="btn-icon" (click)="clearChat()" title="Limpiar chat">
        <i class="bi bi-trash"></i>
      </button>
      <button class="btn-icon" (click)="toggleChat()" title="Cerrar">
        <i class="bi bi-x-lg"></i>
      </button>
    </div>
  </div>

  <!-- Messages -->
  <div class="chat-messages" #messagesContainer>
    <div *ngFor="let message of messages" 
         class="message" 
         [class.user]="message.role === 'user'"
         [class.assistant]="message.role === 'assistant'">
      <div class="message-avatar">
        <i class="bi" [class.bi-person-circle]="message.role === 'user'"
                       [class.bi-robot]="message.role === 'assistant'"></i>
      </div>
      <div class="message-content">
        <div class="message-text" [innerHTML]="formatMessage(message.content)"></div>
        <div class="message-time">{{ message.timestamp | date:'short' }}</div>
      </div>
    </div>

    <!-- Loading indicator -->
    <div *ngIf="isLoading" class="message assistant">
      <div class="message-avatar">
        <i class="bi bi-robot"></i>
      </div>
      <div class="message-content">
        <div class="typing-indicator">
          <span></span>
          <span></span>
          <span></span>
        </div>
      </div>
    </div>
  </div>

  <!-- Quick Questions -->
  <div class="quick-questions" *ngIf="messages.length <= 1">
    <p class="quick-title">Preguntas frecuentes:</p>
    <button *ngFor="let q of quickQuestions" 
            class="quick-btn"
            (click)="sendQuickQuestion(q)">
      {{ q }}
    </button>
  </div>

  <!-- Input -->
  <div class="chat-input">
    <input type="text" 
           [(ngModel)]="userInput"
           (keyup.enter)="sendMessage()"
           placeholder="Escribe tu mensaje..."
           [disabled]="isLoading"
           class="form-control">
    <button (click)="sendMessage()" 
            [disabled]="!userInput.trim() || isLoading"
            class="btn-send">
      <i class="bi bi-send-fill"></i>
    </button>
  </div>
</div>
```

Continúa en siguiente archivo...
