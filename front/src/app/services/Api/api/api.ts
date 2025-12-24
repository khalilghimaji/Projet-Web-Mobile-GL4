export * from './app.service';
import { AppService } from './app.service';
export * from './authentication.service';
import { AuthenticationService } from './authentication.service';
export * from './notifications.service';
import { NotificationsService } from './notifications.service';
export * from './userRating.service';
import { UserRatingService } from './userRating.service';
export const APIS = [AppService, AuthenticationService, NotificationsService, UserRatingService];
