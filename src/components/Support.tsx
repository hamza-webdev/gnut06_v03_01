import { Heart, CreditCard, UserPlus, Share2 } from 'lucide-react';
import { Button } from '@/components/ui/button';
import heroImage from '@/assets/hero-vr.jpg';

const Support = () => {
  const supportMethods = [
    {
      icon: CreditCard,
      title: "Don Financier",
      description: "Soutenez nos projets d'inclusion numérique avec un don sécurisé",
      action: "Faire un Don",
      highlight: "Déductible d'impôts"
    },
    {
      icon: UserPlus,
      title: "Bénévolat",
      description: "Rejoignez notre équipe et partagez vos compétences techniques",
      action: "Devenir Bénévole",
      highlight: "Formation incluse"
    },
    {
      icon: Share2,
      title: "Partage",
      description: "Aidez-nous à faire connaître GNUT06 dans votre réseau",
      action: "Partager",
      highlight: "Impact immédiat"
    }
  ];

  return (
    <section className="section-container">
      <div className="grid lg:grid-cols-2 gap-16 items-center">
        {/* Left content */}
        <div>
          <h2 className="text-4xl md:text-5xl font-bold mb-6">
            Comment vous pouvez <span className="text-gradient">nous aider</span>
          </h2>
          
          <p className="text-lg text-muted-foreground mb-8">
            Votre soutien nous permet de démocratiser l'accès aux nouvelles technologies 
            et de créer des opportunités d'inclusion numérique pour tous.
          </p>

          <div className="space-y-6 mb-8">
            {supportMethods.map((method, index) => (
              <div key={index} className="flex items-start gap-4 p-4 rounded-xl bg-card/50 border border-border/50 hover:bg-card/70 transition-all duration-300">
                <div className="flex-shrink-0 w-12 h-12 bg-gradient-to-br from-primary to-secondary rounded-lg flex items-center justify-center">
                  <method.icon className="h-6 w-6 text-primary-foreground" />
                </div>
                <div className="flex-1">
                  <div className="flex items-center gap-2 mb-1">
                    <h3 className="font-semibold text-lg">{method.title}</h3>
                    <span className="px-2 py-1 bg-accent/20 text-accent text-xs rounded-full">
                      {method.highlight}
                    </span>
                  </div>
                  <p className="text-muted-foreground text-sm mb-3">{method.description}</p>
                  <Button variant="outline" size="sm" className="border-primary text-primary hover:bg-primary hover:text-primary-foreground">
                    {method.action}
                  </Button>
                </div>
              </div>
            ))}
          </div>

          {/* Stats */}
          <div className="grid grid-cols-3 gap-6 p-6 bg-gradient-to-r from-card/50 to-muted/50 rounded-xl border border-border/50">
            <div className="text-center">
              <div className="text-2xl font-bold text-primary">250+</div>
              <div className="text-sm text-muted-foreground">Bénéficiaires</div>
            </div>
            <div className="text-center">
              <div className="text-2xl font-bold text-secondary">50+</div>
              <div className="text-sm text-muted-foreground">Bénévoles</div>
            </div>
            <div className="text-center">
              <div className="text-2xl font-bold text-accent">15</div>
              <div className="text-sm text-muted-foreground">Partenaires</div>
            </div>
          </div>
        </div>

        {/* Right image */}
        <div className="relative">
          <div className="relative overflow-hidden rounded-2xl">
            <img 
              src={heroImage} 
              alt="Support GNUT06" 
              className="w-full h-[600px] object-cover"
            />
            <div className="absolute inset-0 bg-gradient-to-t from-background/80 to-transparent" />
            
            {/* Overlay content */}
            <div className="absolute bottom-8 left-8 right-8">
              <div className="bg-card/90 backdrop-blur-sm border border-border rounded-xl p-6">
                <div className="flex items-center gap-3 mb-3">
                  <Heart className="h-6 w-6 text-red-500" />
                  <span className="font-semibold">Impact de votre soutien</span>
                </div>
                <p className="text-sm text-muted-foreground">
                  "Grâce à GNUT06, j'ai découvert la programmation VR et j'ai maintenant un stage dans une entreprise tech !"
                </p>
                <div className="mt-3 text-xs text-muted-foreground">
                  - Sarah, 17 ans, bénéficiaire
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
};

export default Support;