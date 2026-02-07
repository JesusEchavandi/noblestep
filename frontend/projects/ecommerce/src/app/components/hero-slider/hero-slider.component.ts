import { Component, OnInit, OnDestroy } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';

interface Slide {
  id: number;
  title: string;
  subtitle: string;
  description: string;
  buttonText: string;
  buttonLink: string;
  imageUrl?: string;
  backgroundColor: string;
}

@Component({
  selector: 'app-hero-slider',
  standalone: true,
  imports: [CommonModule, RouterModule],
  template: `
    <div class="hero-slider">
      <div class="slides-container">
        @for (slide of slides; track slide.id; let i = $index) {
          <div class="slide" 
               [class.active]="currentSlide === i"
               [style.background]="slide.backgroundColor">
            <div class="slide-content">
              <div class="text-content">
                <span class="subtitle" [@fadeIn]>{{ slide.subtitle }}</span>
                <h1 class="title" [@fadeIn]>{{ slide.title }}</h1>
                <p class="description" [@fadeIn]>{{ slide.description }}</p>
                <a [routerLink]="slide.buttonLink" class="cta-button" [@fadeIn]>
                  {{ slide.buttonText }}
                  <span class="arrow">→</span>
                </a>
              </div>
              @if (slide.imageUrl) {
                <div class="image-content">
                  <img [src]="slide.imageUrl" [alt]="slide.title">
                </div>
              }
            </div>
          </div>
        }
      </div>

      <!-- Navigation Arrows -->
      <button class="nav-button prev" (click)="prevSlide()" aria-label="Previous slide">
        ‹
      </button>
      <button class="nav-button next" (click)="nextSlide()" aria-label="Next slide">
        ›
      </button>

      <!-- Indicators -->
      <div class="indicators">
        @for (slide of slides; track slide.id; let i = $index) {
          <button 
            class="indicator" 
            [class.active]="currentSlide === i"
            (click)="goToSlide(i)"
            [attr.aria-label]="'Go to slide ' + (i + 1)">
          </button>
        }
      </div>
    </div>
  `,
  styles: [`
    .hero-slider {
      position: relative;
      width: 100%;
      height: 500px;
      overflow: hidden;
      border-radius: 0 0 var(--radius-lg) var(--radius-lg);
    }

    .slides-container {
      position: relative;
      width: 100%;
      height: 100%;
    }

    .slide {
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      opacity: 0;
      transition: opacity 0.8s ease-in-out;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .slide.active {
      opacity: 1;
      z-index: 1;
    }

    .slide-content {
      max-width: 1200px;
      width: 100%;
      padding: 0 var(--spacing-xl);
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: var(--spacing-2xl);
      align-items: center;
    }

    .text-content {
      color: var(--color-white);
      z-index: 2;
    }

    .subtitle {
      display: block;
      font-size: var(--font-size-lg);
      font-weight: 500;
      margin-bottom: var(--spacing-sm);
      opacity: 0.9;
      text-transform: uppercase;
      letter-spacing: 2px;
    }

    .title {
      font-size: var(--font-size-4xl);
      font-weight: bold;
      margin-bottom: var(--spacing-md);
      line-height: 1.2;
      text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.2);
    }

    .description {
      font-size: var(--font-size-lg);
      margin-bottom: var(--spacing-xl);
      opacity: 0.95;
      line-height: 1.6;
    }

    .cta-button {
      display: inline-flex;
      align-items: center;
      gap: var(--spacing-sm);
      background: var(--color-white);
      color: var(--color-dark);
      padding: var(--spacing-md) var(--spacing-xl);
      border-radius: var(--radius-full);
      text-decoration: none;
      font-weight: 600;
      font-size: var(--font-size-lg);
      transition: var(--transition-base);
      box-shadow: var(--shadow-lg);
    }

    .cta-button:hover {
      transform: translateY(-2px);
      box-shadow: var(--shadow-xl);
    }

    .arrow {
      transition: var(--transition-base);
      font-size: var(--font-size-xl);
    }

    .cta-button:hover .arrow {
      transform: translateX(4px);
    }

    .image-content {
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .image-content img {
      max-width: 100%;
      height: auto;
      filter: drop-shadow(0 10px 30px rgba(0, 0, 0, 0.3));
      animation: float 6s ease-in-out infinite;
    }

    @keyframes float {
      0%, 100% { transform: translateY(0px); }
      50% { transform: translateY(-20px); }
    }

    /* Navigation Buttons */
    .nav-button {
      position: absolute;
      top: 50%;
      transform: translateY(-50%);
      background: rgba(255, 255, 255, 0.9);
      color: var(--color-dark);
      border: none;
      width: 50px;
      height: 50px;
      border-radius: var(--radius-full);
      font-size: var(--font-size-3xl);
      cursor: pointer;
      z-index: 10;
      transition: var(--transition-base);
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: var(--shadow-md);
    }

    .nav-button:hover {
      background: var(--color-white);
      transform: translateY(-50%) scale(1.1);
    }

    .nav-button.prev {
      left: var(--spacing-xl);
    }

    .nav-button.next {
      right: var(--spacing-xl);
    }

    /* Indicators */
    .indicators {
      position: absolute;
      bottom: var(--spacing-xl);
      left: 50%;
      transform: translateX(-50%);
      display: flex;
      gap: var(--spacing-sm);
      z-index: 10;
    }

    .indicator {
      width: 12px;
      height: 12px;
      border-radius: var(--radius-full);
      background: rgba(255, 255, 255, 0.5);
      border: 2px solid var(--color-white);
      cursor: pointer;
      transition: var(--transition-base);
      padding: 0;
    }

    .indicator.active {
      background: var(--color-white);
      width: 40px;
    }

    .indicator:hover {
      background: rgba(255, 255, 255, 0.8);
    }

    /* Responsive */
    @media (max-width: 768px) {
      .hero-slider {
        height: 400px;
      }

      .slide-content {
        grid-template-columns: 1fr;
        text-align: center;
      }

      .image-content {
        display: none;
      }

      .title {
        font-size: var(--font-size-3xl);
      }

      .description {
        font-size: var(--font-size-base);
      }

      .nav-button {
        width: 40px;
        height: 40px;
        font-size: var(--font-size-2xl);
      }

      .nav-button.prev {
        left: var(--spacing-sm);
      }

      .nav-button.next {
        right: var(--spacing-sm);
      }
    }
  `]
})
export class HeroSliderComponent implements OnInit, OnDestroy {
  currentSlide = 0;
  autoplayInterval: any;

  slides: Slide[] = [
    {
      id: 1,
      title: '¡Bienvenido a NobleStep!',
      subtitle: 'Nueva Colección',
      description: 'Descubre nuestra exclusiva selección de productos de la más alta calidad',
      buttonText: 'Explorar Ahora',
      buttonLink: '/catalog',
      backgroundColor: 'linear-gradient(135deg, var(--color-success) 0%, var(--color-secondary) 100%)'
    },
    {
      id: 2,
      title: 'Ofertas Especiales',
      subtitle: 'Hasta 50% de Descuento',
      description: 'Aprovecha nuestras increíbles promociones por tiempo limitado',
      buttonText: 'Ver Ofertas',
      buttonLink: '/catalog',
      backgroundColor: 'linear-gradient(135deg, var(--color-primary) 0%, var(--color-secondary) 100%)'
    },
    {
      id: 3,
      title: 'Envío Gratis',
      subtitle: 'En Compras Mayores a S/ 100',
      description: 'Recibe tus productos favoritos sin costo de envío',
      buttonText: 'Comprar Ahora',
      buttonLink: '/catalog',
      backgroundColor: 'linear-gradient(135deg, var(--color-secondary) 0%, var(--color-cream) 100%)'
    }
  ];

  ngOnInit() {
    this.startAutoplay();
  }

  ngOnDestroy() {
    this.stopAutoplay();
  }

  startAutoplay() {
    this.autoplayInterval = setInterval(() => {
      this.nextSlide();
    }, 5000); // Change slide every 5 seconds
  }

  stopAutoplay() {
    if (this.autoplayInterval) {
      clearInterval(this.autoplayInterval);
    }
  }

  nextSlide() {
    this.currentSlide = (this.currentSlide + 1) % this.slides.length;
  }

  prevSlide() {
    this.currentSlide = this.currentSlide === 0 ? this.slides.length - 1 : this.currentSlide - 1;
  }

  goToSlide(index: number) {
    this.currentSlide = index;
    this.stopAutoplay();
    this.startAutoplay();
  }
}
