import { Headphones, Monitor, Users } from 'lucide-react';
import { Button } from '@/components/ui/button';
import vrImage from '@/assets/vr-experience.jpg';

const VRExperience = () => {
  const features = [
    {
      icon: Headphones,
      title: "Expérience Immersive",
      description: "Plongez dans des mondes virtuels avec nos casques VR dernière génération"
    },
    {
      icon: Monitor,
      title: "Interface Intuitive", 
      description: "Des interfaces conçues pour être accessibles à tous les niveaux"
    },
    {
      icon: Users,
      title: "Expérience Collaborative",
      description: "Partagez vos aventures avec d'autres utilisateurs en temps réel"
    }
  ];

  return (
    <section className="section-container">
      <div className="grid lg:grid-cols-2 gap-16 items-center">
        {/* Left content */}
        <div>
          <h2 className="text-4xl md:text-5xl font-bold mb-6">
            Vivez une <span className="text-gradient">expérience immersive</span> inoubliable !
          </h2>
          
          <p className="text-lg text-muted-foreground mb-8">
            Découvrez la puissance de la réalité virtuelle avec nos équipements 
            de pointe et nos espaces spécialement conçus pour l'inclusion numérique.
          </p>

          {/* Features */}
          <div className="space-y-6 mb-8">
            {features.map((feature, index) => (
              <div key={index} className="flex items-start gap-4">
                <div className="flex-shrink-0 w-12 h-12 bg-gradient-to-br from-primary to-secondary rounded-lg flex items-center justify-center">
                  <feature.icon className="h-6 w-6 text-primary-foreground" />
                </div>
                <div>
                  <h3 className="font-semibold text-lg mb-1">{feature.title}</h3>
                  <p className="text-muted-foreground">{feature.description}</p>
                </div>
              </div>
            ))}
          </div>

          <Button className="btn-tech">
            Réserver une Session
          </Button>
        </div>

        {/* Right image */}
        <div className="relative">
          <div className="relative overflow-hidden rounded-2xl">
            <img 
              src={vrImage} 
              alt="VR Experience" 
              className="w-full h-[600px] object-cover"
            />
            <div className="absolute inset-0 bg-gradient-to-t from-background/60 to-transparent" />
          </div>
          
          {/* Floating stats */}
          <div className="absolute top-8 right-8 bg-card/90 backdrop-blur-sm border border-border rounded-xl p-4">
            <div className="text-2xl font-bold text-primary">98%</div>
            <div className="text-sm text-muted-foreground">Satisfaction</div>
          </div>
          
          <div className="absolute bottom-8 left-8 bg-card/90 backdrop-blur-sm border border-border rounded-xl p-4">
            <div className="text-2xl font-bold text-secondary">500+</div>
            <div className="text-sm text-muted-foreground">Utilisateurs</div>
          </div>
        </div>
      </div>
    </section>
  );
};

export default VRExperience;