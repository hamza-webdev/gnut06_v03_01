import { Gamepad2, Globe, Palette } from 'lucide-react';
import { Button } from '@/components/ui/button';
import techHubsImage from '@/assets/tech-hubs.jpg';

const Hubs = () => {
  const hubs = [
    {
      icon: Gamepad2,
      title: "Gaming et GNUT",
      description: "Espace dédié aux jeux vidéo et à l'esport avec équipements gaming professionnels",
      image: techHubsImage,
      features: ["Gaming haute performance", "Tournois esport", "Formation gaming"]
    },
    {
      icon: Globe,
      title: "Metaverse GNUT",
      description: "Explorez les mondes virtuels et créez vos propres expériences immersives",
      image: techHubsImage,
      features: ["Création de mondes", "Événements virtuels", "Collaboration 3D"]
    },
    {
      icon: Palette,
      title: "3D Design",
      description: "Studio de création 3D pour donner vie à vos idées les plus innovantes",
      image: techHubsImage,
      features: ["Modélisation 3D", "Animation", "Impression 3D"]
    }
  ];

  return (
    <section id="hubs" className="section-container bg-muted/30">
      <div className="text-center mb-16">
        <h2 className="text-4xl md:text-5xl font-bold mb-6">
          Explorez nos <span className="text-gradient">Hubs</span>
        </h2>
        <p className="text-lg text-muted-foreground max-w-3xl mx-auto">
          Découvrez nos espaces technologiques spécialisés, chacun conçu pour offrir 
          une expérience unique dans l'univers du numérique et de l'innovation.
        </p>
      </div>

      <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
        {hubs.map((hub, index) => (
          <div key={index} className="card-tech group cursor-pointer">
            {/* Image */}
            <div className="relative overflow-hidden rounded-xl mb-6">
              <img 
                src={hub.image} 
                alt={hub.title}
                className="w-full h-48 object-cover transition-transform duration-300 group-hover:scale-110"
              />
              <div className="absolute inset-0 bg-gradient-to-t from-background/80 to-transparent" />
              
              {/* Icon overlay */}
              <div className="absolute top-4 left-4 w-12 h-12 bg-gradient-to-br from-primary to-secondary rounded-lg flex items-center justify-center">
                <hub.icon className="h-6 w-6 text-primary-foreground" />
              </div>
            </div>

            {/* Content */}
            <div>
              <h3 className="text-xl font-bold mb-3">{hub.title}</h3>
              <p className="text-muted-foreground mb-4">{hub.description}</p>
              
              {/* Features */}
              <ul className="space-y-2 mb-6">
                {hub.features.map((feature, idx) => (
                  <li key={idx} className="flex items-center text-sm text-muted-foreground">
                    <div className="w-1.5 h-1.5 bg-primary rounded-full mr-3" />
                    {feature}
                  </li>
                ))}
              </ul>

              <Button variant="outline" className="w-full border-primary text-primary hover:bg-primary hover:text-primary-foreground">
                Visiter ce Hub
              </Button>
            </div>
          </div>
        ))}
      </div>
    </section>
  );
};

export default Hubs;