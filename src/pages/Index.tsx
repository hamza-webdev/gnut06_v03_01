import Header from '@/components/Header';
import Hero from '@/components/Hero';
import VRExperience from '@/components/VRExperience';
import Hubs from '@/components/Hubs';
import ImmersiveRooms from '@/components/ImmersiveRooms';
import Events from '@/components/Events';
import Support from '@/components/Support';
import Team from '@/components/Team';
import Footer from '@/components/Footer';

const Index = () => {
  return (
    <div className="min-h-screen bg-background">
      <Header />
      <main>
        <Hero />
        <VRExperience />
        <Hubs />
        <ImmersiveRooms />
        <Events />
        <Support />
        <Team />
      </main>
      <Footer />
    </div>
  );
};

export default Index;
