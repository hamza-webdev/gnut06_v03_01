import { Box, Zap, Users2 } from 'lucide-react';
import { Button } from '@/components/ui/button';
import roomImage from '@/assets/3d-room.jpg';

const ImmersiveRooms = () => {
  const features = [
    {
      icon: Box,
      title: "Environnements 3D",
      description: "Des salles entièrement immersives avec projection 360°"
    },
    {
      icon: Zap,
      title: "Technologie Avancée",
      description: "Capteurs de mouvement et interactions gestuelles"
    },
    {
      icon: Users2,
      title: "Expériences Collectives",
      description: "Jusqu'à 12 personnes simultanément dans l'expérience"
    }
  ];

  return (
    <section id="salles" className="section-container">
      <div className="grid lg:grid-cols-2 gap-16 items-center">
        {/* Left image */}
        <div className="relative order-2 lg:order-1">
          <div className="relative overflow-hidden rounded-2xl">
            <img 
              src={roomImage} 
              alt="Salle 3D Immersive" 
              className="w-full h-[600px] object-cover"
            />
            <div className="absolute inset-0 bg-gradient-to-t from-background/60 to-transparent" />
          </div>
          
          {/* Floating elements */}
          <div className="absolute -top-8 -right-8 w-32 h-32 bg-gradient-to-br from-accent/30 to-primary/30 rounded-full blur-xl" />
          <div className="absolute -bottom-8 -left-8 w-24 h-24 bg-gradient-to-br from-secondary/30 to-accent/30 rounded-full blur-xl" />
        </div>

        {/* Right content */}
        <div className="order-1 lg:order-2">
          <h2 className="text-4xl md:text-5xl font-bold mb-6">
            Découvrez nos <span className="text-gradient">Salles 3D</span> immersives
          </h2>
          
          <p className="text-lg text-muted-foreground mb-8">
            Plongez dans des environnements virtuels époustouflants grâce à nos salles 
            équipées des dernières technologies d'immersion 3D et de réalité augmentée.
          </p>

          {/* Features grid */}
          <div className="grid gap-6 mb-8">
            {features.map((feature, index) => (
              <div key={index} className="flex items-start gap-4 p-4 rounded-xl bg-card/50 border border-border/50">
                <div className="flex-shrink-0 w-12 h-12 bg-gradient-to-br from-primary to-secondary rounded-lg flex items-center justify-center">
                  <feature.icon className="h-6 w-6 text-primary-foreground" />
                </div>
                <div>
                  <h3 className="font-semibold text-lg mb-1">{feature.title}</h3>
                  <p className="text-muted-foreground text-sm">{feature.description}</p>
                </div>
              </div>
            ))}
          </div>

          <div className="flex flex-col sm:flex-row gap-4">
            <Button className="btn-tech">
              Réserver une Salle
            </Button>
            <Button className="btn-tech-outline">
              Visite Virtuelle
            </Button>
          </div>
        </div>
      </div>
    </section>
  );
};

export default ImmersiveRooms;