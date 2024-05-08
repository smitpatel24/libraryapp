import Navigation from "../components/Navigation";

export default function Home() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-between p-24">
      <h1 className="text-3xl font-bold mb-2">
        Digital Library Management System
      </h1>
      <Navigation />
    </main>
  );
}
