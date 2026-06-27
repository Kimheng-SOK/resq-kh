import type { AdminRole } from '@/lib/auth-types';

// ── Pagination ──
export interface PaginatedResponse<T> {
  data: T[];
  total: number;
  page: number;
  limit: number;
  totalPages: number;
}

// ── Analytics ──
export interface DashboardOverview {
  totalUsers: number;
  activeAlerts: number;
  pendingReports: number;
  totalServices: number;
  servicesByCategory: { category: string; count: number }[];
  totalNotifications: number;
  unreadNotifications: number;
  recentTrends: {
    newUsersThisWeek: number;
    newUsersLastWeek: number;
    alertsThisWeek: number;
    alertsLastWeek: number;
  };
}

export interface TimeSeriesPoint {
  period: string;
  count: string;
}

export interface StatusBreakdown {
  status: string;
  count: string;
}

export interface AlertTypeBreakdown {
  typeId: string;
  label: string;
  color: string;
  count: string;
}

export interface ResponseTimeMetrics {
  averageMinutes: number;
  byType: { typeId: string; label: string; averageMinutes: number }[];
}

export interface ActivityItem {
  id: string;
  type: 'alert' | 'report' | 'user' | 'notification';
  description: string;
  status: string;
  timestamp: string;
  relatedId: string | undefined;
}

export interface AlertMapPoint {
  id: string;
  lat: number;
  lng: number;
  type: string;
}

// ── Emergency Report ──
export interface EmergencyReport {
  id: string;
  user_id: string;
  incident_type_id: string;
  incidentType?: { id: string; slug: string; label: string; icon_name: string };
  reporter_name: string;
  reporter_phone: string;
  description: string | null;
  latitude: number | null;
  longitude: number | null;
  status: 'pending' | 'dispatched' | 'resolved';
  created_at: string;
  updated_at: string;
}

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
  service_id?: string;
  emergency_report_id?: string;
  user_id?: string;
  type?: 'report_alert' | 'admin_broadcast' | 'admin_direct';
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
