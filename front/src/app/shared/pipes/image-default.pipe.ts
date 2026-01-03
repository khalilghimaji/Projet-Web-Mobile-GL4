import { Pipe, PipeTransform } from '@angular/core';
import memo from 'memo-decorator';
@Pipe({
  name: 'imageDefault',
  pure: true,
  standalone: true,
})
export class ImageDefaultPipe implements PipeTransform {
  @memo()
  transform(value: string | undefined, ...args: unknown[]) {
    return value || '/images/person.png';
  }
}
