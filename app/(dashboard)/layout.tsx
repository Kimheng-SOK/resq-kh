import Link from 'next/link';
import {
  Activity,
  Bell,
  Building2,
  FileText,
  HeartPulse,
  LayoutDashboard,
  PanelLeft,
  Settings,
  Shield,
  Users2
} from 'lucide-react';

import { Button } from '@/components/ui/button';
import { Sheet, SheetContent, SheetTrigger } from '@/components/ui/sheet';
import {
  Tooltip,
  TooltipContent,
  TooltipTrigger
} from '@/components/ui/tooltip';
import { User } from './user';
import Providers from './providers';
import { NavItem } from './nav-item';
import { SearchInput } from './search';
import { DashboardBreadcrumb } from './breadcrumb';
import { getSession } from '@/lib/session';
import type { AdminRole } from '@/lib/auth-types';

export default async function DashboardLayout({
  children
}: {
  children: React.ReactNode;
}) {
  const session = await getSession();
  const role: AdminRole = session?.role || 'viewer';

  return (
    <Providers>
      <main className="flex min-h-screen w-full flex-col bg-muted/40">
        <DesktopNav role={role} />
        <div className="flex flex-col sm:gap-4 sm:py-4 sm:pl-14">
          <header className="sticky top-0 z-30 flex h-14 items-center gap-4 border-b bg-background px-4 sm:static sm:h-auto sm:border-0 sm:bg-transparent sm:px-6">
            <MobileNav role={role} />
            <DashboardBreadcrumb />
            <SearchInput />
            <User />
          </header>
          <main className="grid flex-1 items-start gap-2 p-4 sm:px-6 sm:py-0 md:gap-4">
            {children}
          </main>
        </div>
      </main>
    </Providers>
  );
}

function DesktopNav({ role }: { role: AdminRole }) {
  return (
    <aside className="fixed inset-y-0 left-0 z-10 hidden w-14 flex-col border-r bg-background sm:flex">
      <nav className="flex flex-col items-center gap-4 px-2 sm:py-5">
        <Link
          href="/"
          className="group flex h-9 w-9 shrink-0 items-center justify-center gap-2 rounded-full bg-primary text-lg font-semibold text-primary-foreground md:h-8 md:w-8 md:text-base"
        >
          <HeartPulse className="h-4 w-4 transition-all group-hover:scale-110" />
          <span className="sr-only">ResQ Admin</span>
        </Link>

        <NavItem href="/" label="Dashboard">
          <LayoutDashboard className="h-5 w-5" />
        </NavItem>

        <NavItem href="/monitoring" label="Monitoring">
          <Activity className="h-5 w-5" />
        </NavItem>

        <NavItem href="/emergency-reports" label="Emergency Reports">
          <FileText className="h-5 w-5" />
        </NavItem>

        <NavItem href="/notifications" label="Notifications">
          <Bell className="h-5 w-5" />
        </NavItem>

        <NavItem href="/users" label="Users">
          <Users2 className="h-5 w-5" />
        </NavItem>

        <NavItem href="/services" label="Services">
          <Building2 className="h-5 w-5" />
        </NavItem>

        <NavItem href="/first-aid" label="First Aid">
          <HeartPulse className="h-5 w-5" />
        </NavItem>

        {role === 'super_admin' && (
          <NavItem href="/admins" label="Admins">
            <Shield className="h-5 w-5" />
          </NavItem>
        )}
      </nav>
      <nav className="mt-auto flex flex-col items-center gap-4 px-2 sm:py-5">
        <Tooltip>
          <TooltipTrigger asChild>
            <Link
              href="/settings"
              className="flex h-9 w-9 items-center justify-center rounded-lg text-muted-foreground transition-colors hover:text-foreground md:h-8 md:w-8"
            >
              <Settings className="h-5 w-5" />
              <span className="sr-only">Settings</span>
            </Link>
          </TooltipTrigger>
          <TooltipContent side="right">Settings</TooltipContent>
        </Tooltip>
      </nav>
    </aside>
  );
}

function MobileNav({ role }: { role: AdminRole }) {
  return (
    <Sheet>
      <SheetTrigger asChild>
        <Button size="icon" variant="outline" className="sm:hidden">
          <PanelLeft className="h-5 w-5" />
          <span className="sr-only">Toggle Menu</span>
        </Button>
      </SheetTrigger>
      <SheetContent side="left" className="sm:max-w-xs">
        <nav className="grid gap-6 text-lg font-medium">
          <Link
            href="/"
            className="group flex h-10 w-10 shrink-0 items-center justify-center gap-2 rounded-full bg-primary text-lg font-semibold text-primary-foreground md:text-base"
          >
            <HeartPulse className="h-5 w-5 transition-all group-hover:scale-110" />
            <span className="sr-only">ResQ Admin</span>
          </Link>
          <Link
            href="/"
            className="flex items-center gap-4 px-2.5 text-muted-foreground hover:text-foreground"
          >
            <LayoutDashboard className="h-5 w-5" />
            Dashboard
          </Link>
          <Link
            href="/monitoring"
            className="flex items-center gap-4 px-2.5 text-muted-foreground hover:text-foreground"
          >
            <Activity className="h-5 w-5" />
            Monitoring
          </Link>
          <Link
            href="/emergency-reports"
            className="flex items-center gap-4 px-2.5 text-muted-foreground hover:text-foreground"
          >
            <FileText className="h-5 w-5" />
            Emergency Reports
          </Link>
          <Link
            href="/notifications"
            className="flex items-center gap-4 px-2.5 text-muted-foreground hover:text-foreground"
          >
            <Bell className="h-5 w-5" />
            Notifications
          </Link>
          <Link
            href="/users"
            className="flex items-center gap-4 px-2.5 text-muted-foreground hover:text-foreground"
          >
            <Users2 className="h-5 w-5" />
            Users
          </Link>
          <Link
            href="/services"
            className="flex items-center gap-4 px-2.5 text-muted-foreground hover:text-foreground"
          >
            <Building2 className="h-5 w-5" />
            Services
          </Link>
          <Link
            href="/first-aid"
            className="flex items-center gap-4 px-2.5 text-muted-foreground hover:text-foreground"
          >
            <HeartPulse className="h-5 w-5" />
            First Aid
          </Link>
          {role === 'super_admin' && (
            <Link
              href="/admins"
              className="flex items-center gap-4 px-2.5 text-muted-foreground hover:text-foreground"
            >
              <Shield className="h-5 w-5" />
              Admins
            </Link>
          )}
          <Link
            href="/settings"
            className="flex items-center gap-4 px-2.5 text-muted-foreground hover:text-foreground"
          >
            <Settings className="h-5 w-5" />
            Settings
          </Link>
        </nav>
      </SheetContent>
    </Sheet>
  );
}
