import { Injectable } from '@angular/core';
import {
    HttpEvent,
    HttpHandler,
    HttpInterceptor,
    HttpRequest,
} from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../../environments/environment';

@Injectable()
export class ApiKeyInterceptor implements HttpInterceptor {
    constructor() { }

    intercept(
        request: HttpRequest<unknown>,
        next: HttpHandler
    ): Observable<HttpEvent<unknown>> {
        // Check if the request is for the AllSportsAPI
        if (request.url.startsWith(environment.allSportsApi.baseUrl)) {

            // Let's just add the param.
            const authReq = request.clone({
                params: request.params.set('APIkey', environment.allSportsApi.apiKey),
            });

            return next.handle(authReq);
        }

        return next.handle(request);
    }
}
