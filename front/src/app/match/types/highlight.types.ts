/**
 * Video highlight and media types
 */

export type HighlightType =
  | 'GOAL'
  | 'SAVE'
  | 'SKILL'
  | 'FOUL'
  | 'INTERVIEW'
  | 'ANALYSIS'
  | 'FULL_MATCH'
  | 'EXTENDED_HIGHLIGHTS';

export interface VideoHighlight {
  id: string;
  title: string;
  thumbnail: string;
  duration: string; // Format: "MM:SS" or "HH:MM:SS"
  url: string;
  type?: HighlightType;
  views?: number;
  uploadDate?: Date;
}

export interface MediaGallery {
  videos: VideoHighlight[];
  images?: MediaImage[];
  totalCount: number;
}

export interface MediaImage {
  id: string;
  url: string;
  caption?: string;
  timestamp?: Date;
}
