import { IsNotEmpty, IsString } from 'class-validator';

export class FirebaseLoginDto {
  @IsNotEmpty()
  @IsString()
  firebaseToken: string;
}
