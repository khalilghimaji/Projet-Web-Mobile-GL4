import {
  createParamDecorator,
  ExecutionContext,
  UnauthorizedException,
} from '@nestjs/common';

export const User = createParamDecorator(
  (data: string, ctx: ExecutionContext) => {
    const request = ctx.switchToHttp().getRequest();
    const user = request?.user;
    if (!user) {
      throw new UnauthorizedException('Not authenticated');
    }
    if (data) return user[data];
    return user;
  },
);
