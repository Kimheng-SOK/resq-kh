import { Button } from '@/components/ui/button';
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger
} from '@/components/ui/dropdown-menu';
import { logoutAction } from '@/lib/auth-client';
import { getSession } from '@/lib/session';

function getInitials(name: string | null): string {
  if (!name) return '?';
  return name
    .split(' ')
    .map((p) => p[0])
    .join('')
    .toUpperCase()
    .slice(0, 2);
}

function getRoleBadgeClass(role: string): string {
  switch (role) {
    case 'super_admin':
      return 'bg-purple-100 text-purple-800';
    case 'moderator':
      return 'bg-blue-100 text-blue-800';
    default:
      return 'bg-gray-100 text-gray-800';
  }
}

export async function User() {
  const session = await getSession();

  if (!session) {
    return null;
  }

  return (
    <DropdownMenu>
      <DropdownMenuTrigger asChild>
        <Button
          variant="outline"
          size="icon"
          className="overflow-hidden rounded-full"
        >
          <span className="flex h-full w-full items-center justify-center rounded-full bg-primary text-xs font-medium text-primary-foreground">
            {getInitials(session.full_name)}
          </span>
        </Button>
      </DropdownMenuTrigger>
      <DropdownMenuContent align="end">
        <DropdownMenuLabel>
          <div className="flex flex-col gap-1">
            <span>{session.full_name || session.email}</span>
            <span
              className={`inline-flex w-fit items-center rounded-full px-2 py-0.5 text-xs font-medium ${getRoleBadgeClass(session.role)}`}
            >
              {session.role.replace('_', ' ')}
            </span>
          </div>
        </DropdownMenuLabel>
        <DropdownMenuSeparator />
        <DropdownMenuItem>
          <form action={logoutAction} className="w-full">
            <button type="submit" className="w-full text-left">
              Sign Out
            </button>
          </form>
        </DropdownMenuItem>
      </DropdownMenuContent>
    </DropdownMenu>
  );
}
