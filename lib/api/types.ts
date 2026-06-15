import type { AdminRole } from '@/lib/auth-types';

// ── Admin ──
export interface AdminUser {
  id: string;
  email: string;
  full_name: string | null;
  role: AdminRole;
  is_active: boolean;
  last_login_at: string | null;
  created_at: string;
  updated_at: string;
}

// ── User ──
export interface User {
  id: string;
  full_name: string | null;
  email: string | null;
  phone_number: string | null;
  blood_group: string | null;
  allergies: string | null;
  medical_conditions: string | null;
  preferred_language: string;
  dark_mode: string;
  created_at: string;
  updated_at: string;
}

// ── Emergency Type ──
export interface EmergencyType {
  id: string;
  slug: string;
  label: string;
  icon_name: string | null;
  color: string | null;
  sort_order: number;
  is_active: boolean;
}

// ── User Location ──
export interface UserLocation {
  id: string;
  user_id: string;
  latitude: string;
  longitude: string;
  accuracy: string | null;
  captured_at: string;
  created_at: string;
}

// ── Emergency Alert ──
export interface EmergencyAlert {
  id: string;
  user_id: string;
  user: User;
  emergency_type_id: string;
  emergency_type: EmergencyType;
  location_id: string;
  location: UserLocation;
  status: 'active' | 'resolved' | 'cancelled';
  notes: string | null;
  resolved_at: string | null;
  created_at: string;
  updated_at: string;
}

// ── Service ──
export interface Service {
  id: string;
  name: string;
  category: string;
  phone_number: string;
  address: string;
  latitude: number;
  longitude: number;
  description: string | null;
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

// ── Contact ──
export interface Contact {
  id: string;
  user_id: string;
  name: string;
  phone_number: string;
  relationship: string | null;
  sort_order: number;
  created_at: string;
  updated_at: string;
}

// ── Notification ──
export interface Notification {
  id: string;
  user_id: string;
  emergency_alert_id: string | null;
  type: 'sos' | 'contact_alert' | 'system' | 'reminder';
  title: string;
  body: string;
  is_read: boolean;
  created_at: string;
}

// ── First Aid ──
export interface FirstAidTopic {
  id: string;
  slug: string;
  icon_name: string | null;
  severity: 'critical' | 'urgent' | 'stable';
  sort_order: number;
  is_active: boolean;
  translations: FirstAidTranslation[];
  steps: FirstAidStep[];
  created_at: string;
  updated_at: string;
}

export interface FirstAidStep {
  id: string;
  topic_id: string;
  step_number: number;
  is_warning: boolean;
  image_url: string | null;
  translations: FirstAidStepTranslation[];
  created_at: string;
  updated_at: string;
}

export interface FirstAidTranslation {
  id: string;
  topic_id: string;
  language_code: string;
  title: string;
  summary: string | null;
  created_at: string;
}

export interface FirstAidStepTranslation {
  id: string;
  step_id: string;
  language_code: string;
  instruction: string;
  created_at: string;
}
