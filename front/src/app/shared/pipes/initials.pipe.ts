import { Pipe, PipeTransform } from '@angular/core';
import memo from 'memo-decorator';
@Pipe({
  name: 'initials',
  standalone: true,
  pure: true,
})
export class InitialsPipe implements PipeTransform {
  @memo()
  transform(firstName?: string, lastName?: string): string {
    const first = firstName?.charAt(0).toUpperCase() || '';
    const last = lastName?.charAt(0).toUpperCase() || '';
    return first + last;
  }
}
