import { ApiProperty } from '@nestjs/swagger';

export class RankingsUserDto {
  @ApiProperty()
  firstName: string;

  @ApiProperty()
  lastName: string;

  @ApiProperty()
  email: string;

  @ApiProperty()
  score: number;

  @ApiProperty({ required: false })
  imageUrl?: string;
}
