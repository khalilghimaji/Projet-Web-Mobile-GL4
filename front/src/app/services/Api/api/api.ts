export * from './app.service';
import { AppService } from './app.service';
export * from './authentication.service';
import { AuthenticationService } from './authentication.service';
export * from './matches.service';
import { MatchesService } from './matches.service';
export * from './notifications.service';
import { NotificationsService } from './notifications.service';
export const APIS = [AppService, AuthenticationService, MatchesService, NotificationsService];
