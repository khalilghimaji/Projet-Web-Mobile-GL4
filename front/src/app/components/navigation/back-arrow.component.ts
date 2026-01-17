import { Component, viewChild, AfterViewInit, ElementRef } from '@angular/core';
import { Location } from '@angular/common';
import { fromEvent } from 'rxjs';

@Component({
  selector: 'app-back-arrow',
  standalone: true,
  imports: [],
  template: `
    <button #buttonArrow class="back-arrow">
      <img src="/images/img.png" alt="Back" />
    </button>
  `,
  styles: [
    `
      .back-arrow {
        position: fixed;
        top: 20px;
        right: 20px;
        width: 45px;
        height: 45px;
        display: flex;
        justify-content: center;
        align-items: center;
        background-color: rgba(255, 255, 255, 0.1);
        backdrop-filter: blur(8px);
        border: 1px solid rgba(255, 255, 255, 0.2);
        border-radius: 50%;
        cursor: pointer;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        transition: all 0.3s ease;
        z-index: 996;
      }

      .back-arrow:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
        background-color: rgba(255, 255, 255, 0.2);
      }

      .back-arrow img {
        width: 22px;
        height: 22px;
        opacity: 0.7;
        transition: opacity 0.3s ease;
      }

      .back-arrow:hover img {
        opacity: 1;
      }

      @media (max-width: 768px) {
        .back-arrow {
          top: 15px;
          right: 15px;
          width: 40px;
          height: 40px;
        }

        .back-arrow img {
          width: 20px;
          height: 20px;
        }
      }

      @media (max-width: 480px) {
        .back-arrow {
          top: 12px;
          right: 12px;
          width: 38px;
          height: 38px;
        }

        .back-arrow img {
          width: 18px;
          height: 18px;
        }
      }
    `,
  ],
})
export class BackArrowComponent implements AfterViewInit {
  buttonArrowRef = viewChild<ElementRef>('buttonArrow');

  constructor(private location: Location) {}

  ngAfterViewInit(): void {
    const button = this.buttonArrowRef()?.nativeElement;
    if (button) {
      fromEvent(button, 'click').subscribe(() => this.goBack());
    }
  }

  goBack(): void {
    this.location.back();
  }
}
