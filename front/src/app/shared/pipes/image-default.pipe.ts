import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
  name: 'imageDefault',
})
export class ImageDefaultPipe implements PipeTransform {
  transform(value: string | undefined, ...args: unknown[]) {
    return value || '/images/person.png';
  }
}
