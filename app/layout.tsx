import './globals.css';

export const metadata = {
  title: 'ResQ Admin — Emergency Response Platform',
  description:
    'Admin dashboard for the ResQ emergency response platform. Manage users, emergency alerts, services, and first aid content.'
};

export default function RootLayout({
  children
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body className="flex min-h-screen w-full flex-col">{children}</body>
    </html>
  );
}
