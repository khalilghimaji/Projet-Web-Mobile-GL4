import { ApiProperty } from '@nestjs/swagger';
import { UserDto } from './mfa-verify-response.dto';
import { IsOptional } from 'class-validator';

export class LoginResponseDto {
  @ApiProperty({
    description: 'JWT access token',
    example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
  })
  @IsOptional()
  accessToken?: string;

  @ApiProperty({
    description: 'JWT refresh token',
    example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
    required: false,
  })
  @IsOptional()
  refreshToken?: string;

  @ApiProperty({ type: UserDto })
  @IsOptional()
  user?: UserDto;

  @ApiProperty({
    description: 'Message indicating MFA verification is required',
    example: 'MFA verification required',
  })
  @IsOptional()
  message?: string;

  @ApiProperty({
    description: 'Temporary token for MFA verification',
    example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
  })
  @IsOptional()
  mfaToken?: string;

  @ApiProperty({
    description: 'Flag indicating MFA is required',
    example: true,
  })
  @IsOptional()
  isMfaRequired?: boolean;
}
