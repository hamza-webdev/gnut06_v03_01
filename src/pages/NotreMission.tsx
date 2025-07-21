import Header from '@/components/Header';
import Footer from '@/components/Footer';
import { Button } from '@/components/ui/button';
import { Card, CardContent } from '@/components/ui/card';
import { Heart, Users, Eye, Building } from 'lucide-react';

const NotreMission = () => {
  return (
    <div className="min-h-screen bg-background">
      <Header />
      <main className="pt-20">
        {/* Hero Section */}
        <section className="relative py-24 overflow-hidden">
          <div className="absolute inset-0 bg-gradient-radial from-primary/10 via-transparent to-transparent"></div>
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="grid lg:grid-cols-2 gap-12 items-center">
              <div className="space-y-8">
                <h1 className="text-4xl lg:text-6xl font-bold text-gradient">
                  Qui sommes nous ?
                </h1>
                <p className="text-xl text-muted-foreground leading-relaxed">
                  Nous sommes une organisation à but non lucratif, régie par la loi 1901, 
                  basée à Nice. Notre mission est de promouvoir l'inclusion des personnes 
                  en situation de handicap grâce aux technologies innovantes.
                </p>
              </div>
              <div className="relative">
                <div className="bg-card border border-border rounded-2xl p-8 shadow-xl">
                  <img 
                    src="https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=500&h=400&fit=crop" 
                    alt="Personne utilisant la réalité virtuelle"
                    className="w-full h-64 object-cover rounded-lg"
                  />
                </div>
              </div>
            </div>
          </div>
        </section>

        {/* Technologies Section */}
        <section className="py-20 bg-card/50">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="text-center mb-16">
              <div className="inline-flex items-center justify-center w-16 h-16 bg-primary/10 rounded-full mb-6">
                <Eye className="w-8 h-8 text-primary" />
              </div>
              <h2 className="text-3xl lg:text-4xl font-bold mb-6">
                Technologies Innovantes
              </h2>
              <p className="text-lg text-muted-foreground max-w-3xl mx-auto">
                Nous utilisons des outils tels que la réalité virtuelle, la réalité 
                augmentée et la réalité mixte. Nous offrons des expériences 
                immersives qui permettent d'aborder des sujets sensibles du 
                handicap. Ces technologies ouvrent de nouvelles perspectives et 
                brisent les barrières.
              </p>
            </div>
          </div>
        </section>

        {/* Actions Section */}
        <section className="py-20">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <h2 className="text-3xl lg:text-4xl font-bold text-center mb-16">
              Nos actions
            </h2>
            <div className="grid md:grid-cols-3 gap-8">
              <Card className="bg-card border-border hover:shadow-lg transition-shadow">
                <CardContent className="p-8 text-center">
                  <img 
                    src="https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=400&h=250&fit=crop" 
                    alt="Rencontres avec les personnes âgées"
                    className="w-full h-48 object-cover rounded-lg mb-6"
                  />
                  <h3 className="text-xl font-bold mb-4">
                    Rencontres avec les personnes âgées
                  </h3>
                  <p className="text-muted-foreground">
                    GNUT 06 engage à créer des liens intergénérationnels, 
                    en favorisant régulièrement les personnes âgées.
                  </p>
                </CardContent>
              </Card>

              <Card className="bg-card border-border hover:shadow-lg transition-shadow">
                <CardContent className="p-8 text-center">
                  <img 
                    src="https://images.unsplash.com/photo-1605810230434-7631ac76ec81?w=400&h=250&fit=crop" 
                    alt="Visite des hôpitaux"
                    className="w-full h-48 object-cover rounded-lg mb-6"
                  />
                  <h3 className="text-xl font-bold mb-4">
                    Visite des hôpitaux
                  </h3>
                  <p className="text-muted-foreground">
                    Nous nous déplaçons dans les hôpitaux pour proposer des 
                    patients de s'évader grâce à des expériences virtuelles sensibilité.
                  </p>
                </CardContent>
              </Card>

              <Card className="bg-card border-border hover:shadow-lg transition-shadow">
                <CardContent className="p-8 text-center">
                  <img 
                    src="https://images.unsplash.com/photo-1518770660439-4636190af475?w=400&h=250&fit=crop" 
                    alt="Séances d'immersion"
                    className="w-full h-48 object-cover rounded-lg mb-6"
                  />
                  <h3 className="text-xl font-bold mb-4">
                    Séances d'immersion
                  </h3>
                  <p className="text-muted-foreground">
                    Des séances d'immersion en réalité virtuelle et nouvelles 
                    technologies, accessibles à tous, permettent aux personnes 
                    en situation de handicap de découvrir de nouveaux univers.
                  </p>
                </CardContent>
              </Card>
            </div>
          </div>
        </section>

        {/* President Message */}
        <section className="py-20 bg-card/50">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="grid lg:grid-cols-2 gap-12 items-center">
              <div className="space-y-6">
                <h2 className="text-3xl lg:text-4xl font-bold">
                  Mot du Président
                </h2>
                <p className="text-lg text-muted-foreground italic">
                  "Chers membres et visiteurs,"
                </p>
                <p className="text-muted-foreground leading-relaxed">
                  En tant que président de l'association Gnut 06, je suis ravi de vous 
                  accueillir sur notre site. Notre association est une communauté de 
                  passionnés dédiée à l'innovation technologique et à l'inclusion. 
                  Ensemble, nous explorons les frontières de la technologie et créons 
                  les outils liens.
                </p>
                <p className="text-muted-foreground leading-relaxed">
                  À une époque où la technologie évolue rapidement, il est crucial de 
                  garder l'humain au cœur de cette révolution. Chez Gnut 06, nous 
                  croyons que la technologie doit servir l'humanité et favoriser 
                  l'inclusion. Nos engagements à promouvoir des valeurs de partage et de solidarité.
                </p>
                <p className="text-muted-foreground leading-relaxed">
                  Que vous soyez un passionné de technologie, un professionnel en quête 
                  d'inspiration ou nous rend tous. En vous invitant à participer à nos projets 
                  et événements. Votre voix est importante, et ensemble, nous 
                  pouvons faire la différence.
                </p>
                <p className="text-muted-foreground leading-relaxed">
                  Merci de votre soutien. Grâce à avancer vers un monde où la 
                  technologie est au service de l'humain.
                </p>
                <p className="text-muted-foreground">
                  <span className="font-medium">Avec gratitude,</span><br />
                  <span className="font-bold">Michel Col</span><br />
                  <span className="text-sm">Président de Gnut 06</span>
                </p>
              </div>
              <div className="relative">
                <div className="bg-gradient-to-br from-primary/20 to-purple-600/20 rounded-2xl p-8">
                  <img 
                    src="https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=500&h=600&fit=crop" 
                    alt="Michel Col - Président de Gnut 06"
                    className="w-full h-96 object-cover rounded-lg"
                  />
                </div>
              </div>
            </div>
          </div>
        </section>
      </main>
      <Footer />
    </div>
  );
};

export default NotreMission;