import { ArrowRight, Play } from 'lucide-react';
import { Button } from '@/components/ui/button';
import heroImage from '@/assets/hero-vr.jpg';

const Hero = () => {
  return (
    <section id="accueil" className="min-h-screen flex items-center justify-center relative overflow-hidden">
      {/* Background with overlay */}
      <div className="absolute inset-0">
        <img 
          src={heroImage} 
          alt="VR Technology" 
          className="w-full h-full object-cover"
        />
        <div className="absolute inset-0 bg-gradient-to-r from-background/90 via-background/70 to-background/90" />
      </div>

      {/* Content */}
      <div className="relative z-10 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid lg:grid-cols-2 gap-12 items-center">
          {/* Left content */}
          <div className="text-center lg:text-left">
            <h1 className="text-6xl md:text-7xl font-bold leading-tight mb-6">
              <span className="text-gradient">GNUT06</span>
              <br />
              <span className="text-foreground">L'inclusion par</span>
              <br />
              <span className="text-gradient">Technologie</span>
            </h1>
            
            <p className="text-xl text-muted-foreground mb-8 max-w-2xl">
              Nous créons des expériences immersives et innovantes qui rendent la technologie accessible à tous. 
              Découvrez nos espaces de réalité virtuelle et nos solutions inclusives.
            </p>

            <div className="flex flex-col sm:flex-row gap-4 justify-center lg:justify-start">
              <Button className="btn-tech">
                Découvrir nos Hubs
                <ArrowRight className="ml-2 h-5 w-5" />
              </Button>
              <Button className="btn-tech-outline">
                <Play className="mr-2 h-5 w-5" />
                Voir la Démonstration
              </Button>
            </div>
          </div>

          {/* Right content - Additional tech visual elements */}
          <div className="hidden lg:block">
            <div className="relative">
              {/* Floating tech cards */}
              <div className="absolute top-0 right-0 w-32 h-32 bg-gradient-to-br from-primary/20 to-secondary/20 rounded-2xl backdrop-blur-sm border border-primary/30 animate-pulse" />
              <div className="absolute bottom-20 left-10 w-24 h-24 bg-gradient-to-br from-accent/20 to-primary/20 rounded-full backdrop-blur-sm border border-accent/30 animate-pulse" style={{ animationDelay: '1s' }} />
              <div className="absolute top-32 left-1/3 w-20 h-20 bg-gradient-to-br from-secondary/20 to-accent/20 rounded-lg backdrop-blur-sm border border-secondary/30 animate-pulse" style={{ animationDelay: '2s' }} />
            </div>
          </div>
        </div>
      </div>

      {/* Scroll indicator */}
      <div className="absolute bottom-8 left-1/2 transform -translate-x-1/2">
        <div className="w-6 h-10 border-2 border-primary rounded-full flex justify-center">
          <div className="w-1 h-3 bg-primary rounded-full mt-2 animate-bounce" />
        </div>
      </div>
    </section>
  );
};

export default Hero;