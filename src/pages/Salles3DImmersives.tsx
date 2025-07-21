import Header from '@/components/Header';
import Footer from '@/components/Footer';
import { Button } from '@/components/ui/button';
import { Card, CardContent } from '@/components/ui/card';
import { Star, Users, Monitor, Headphones } from 'lucide-react';

const Salles3DImmersives = () => {
  const testimonials = [
    {
      text: "Une expérience immersive qui change la donne !",
      author: "Jean Dupont",
      role: "Développeur VR/AR"
    },
    {
      text: "La métaverse a ouvert de nouvelles perspectives créatives !",
      author: "Marie Claire",
      role: "Graphiste Freelance"
    },
    {
      text: "Une aventure incroyable, je recommande à tous !",
      author: "Pierre Martin",
      role: "Entrepreneur Startup"
    }
  ];

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
                <h1 className="text-4xl lg:text-6xl font-bold">
                  <span className="text-gradient">Les avantages incroyables du 3D Immersif</span> pour votre expérience en ligne.
                </h1>
                <p className="text-xl text-muted-foreground leading-relaxed">
                  Le métaverse offre une immersion totale, transformant la manière dont nous interagissons en ligne, capable des environnements virtuels engageants qui stimulent la créativité et la collaboration.
                </p>
              </div>
              <div className="relative">
                <div className="bg-gradient-to-br from-primary/20 to-purple-600/20 rounded-2xl p-8">
                  <img 
                    src="https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=500&h=400&fit=crop" 
                    alt="Expérience 3D immersive"
                    className="w-full h-64 object-cover rounded-lg"
                  />
                </div>
              </div>
            </div>
          </div>
        </section>

        {/* Navigation Steps */}
        <section className="py-20">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <h2 className="text-3xl lg:text-4xl font-bold text-center mb-16">
              Découvrez comment naviguer dans les Salles 3D Immersives
            </h2>
            
            <div className="grid md:grid-cols-3 gap-8">
              <Card className="bg-card border-border hover:shadow-lg transition-shadow">
                <CardContent className="p-8 text-center">
                  <div className="inline-flex items-center justify-center w-16 h-16 bg-primary/10 rounded-full mb-6">
                    <Users className="w-8 h-8 text-primary" />
                  </div>
                  <h3 className="text-xl font-bold mb-4">
                    Étape 1 : Créez votre avatar
                  </h3>
                  <p className="text-muted-foreground">
                    Personnalisez votre avatar pour mieux votre style privé.
                  </p>
                  <img 
                    src="https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=300&h=200&fit=crop" 
                    alt="Création d'avatar"
                    className="w-full h-32 object-cover rounded-lg mt-4"
                  />
                </CardContent>
              </Card>

              <Card className="bg-card border-border hover:shadow-lg transition-shadow">
                <CardContent className="p-8 text-center">
                  <div className="inline-flex items-center justify-center w-16 h-16 bg-primary/10 rounded-full mb-6">
                    <Monitor className="w-8 h-8 text-primary" />
                  </div>
                  <h3 className="text-xl font-bold mb-4">
                    Étape 2 : Explorez l'environnement
                  </h3>
                  <p className="text-muted-foreground">
                    Découvrez-vous à travers les différents genres de métaverse.
                  </p>
                  <img 
                    src="https://images.unsplash.com/photo-1605810230434-7631ac76ec81?w=300&h=200&fit=crop" 
                    alt="Exploration d'environnement"
                    className="w-full h-32 object-cover rounded-lg mt-4"
                  />
                </CardContent>
              </Card>

              <Card className="bg-card border-border hover:shadow-lg transition-shadow">
                <CardContent className="p-8 text-center">
                  <div className="inline-flex items-center justify-center w-16 h-16 bg-primary/10 rounded-full mb-6">
                    <Headphones className="w-8 h-8 text-primary" />
                  </div>
                  <h3 className="text-xl font-bold mb-4">
                    Étape 3 : Interagissez avec d'autres utilisateurs
                  </h3>
                  <p className="text-muted-foreground">
                    Participez et développez avec d'autres.
                  </p>
                  <img 
                    src="https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=300&h=200&fit=crop" 
                    alt="Interaction avec utilisateurs"
                    className="w-full h-32 object-cover rounded-lg mt-4"
                  />
                </CardContent>
              </Card>
            </div>

            <div className="text-center mt-12">
              <Button className="btn-tech">
                Demander une immersion
              </Button>
            </div>
          </div>
        </section>

        {/* Testimonials */}
        <section className="py-20 bg-card/50">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <h2 className="text-3xl lg:text-4xl font-bold text-center mb-16">
              Témoignages utilisateurs
            </h2>
            <p className="text-center text-muted-foreground mb-12">
              Découvrez ce que nos utilisateurs pensent des salles 3D immersives !
            </p>
            
            <div className="grid md:grid-cols-3 gap-8">
              {testimonials.map((testimonial, index) => (
                <Card key={index} className="bg-card border-border">
                  <CardContent className="p-6">
                    <div className="flex mb-4">
                      {[...Array(5)].map((_, i) => (
                        <Star key={i} className="w-5 h-5 text-yellow-400 fill-current" />
                      ))}
                    </div>
                    <p className="text-muted-foreground mb-4 italic">
                      "{testimonial.text}"
                    </p>
                    <div>
                      <p className="font-medium">{testimonial.author}</p>
                      <p className="text-sm text-muted-foreground">{testimonial.role}</p>
                    </div>
                  </CardContent>
                </Card>
              ))}
            </div>
          </div>
        </section>

        {/* FAQ Section */}
        <section className="py-20">
          <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
            <h2 className="text-3xl lg:text-4xl font-bold text-center mb-16">FAQ</h2>
            <p className="text-center text-muted-foreground mb-12">
              Découvrez les réponses aux questions les plus fréquentes sur le métaverse.
            </p>

            <div className="space-y-8">
              <div className="bg-card border border-border rounded-lg p-6">
                <h3 className="text-xl font-bold mb-4">Qu'est-ce que le métaverse ?</h3>
                <p className="text-muted-foreground">
                  Le métaverse est un espace virtuel immersif où les utilisateurs peuvent interagir, 
                  à travers des avatars digitaux, accédant à des environnements 3D et des expériences 
                  augmentées pour l'interaction, le travail et le divertissement.
                </p>
              </div>

              <div className="bg-card border border-border rounded-lg p-6">
                <h3 className="text-xl font-bold mb-4">Comment y accéder ?</h3>
                <p className="text-muted-foreground">
                  Pour accéder au métaverse, vous devez disposer d'un support compatible, comme un casque VR 
                  ou un ordinateur. Une connexion Internet stable est également essentielle. Inscrivez-vous 
                  pour une expérience complète.
                </p>
              </div>

              <div className="bg-card border border-border rounded-lg p-6">
                <h3 className="text-xl font-bold mb-4">Quels sont les bénéfices ?</h3>
                <p className="text-muted-foreground">
                  Le métaverse offre des expériences éducatives et récréatives et enrichissantes qui permettent de 
                  développement, d'apprendre de nouvelles compétences et de développer des 
                  compétences numériques pour le futur, favorise possibilités technologiques et sociales.
                </p>
              </div>

              <div className="bg-card border border-border rounded-lg p-6">
                <h3 className="text-xl font-bold mb-4">Est-ce sécurisé ?</h3>
                <p className="text-muted-foreground">
                  Oui sécurité une priorité. Nous mettons en place des protocoles de sécurité 
                  robustes pour protéger les données et assurer la confidentialité. Néanmoins respecter les 
                  modalités et conditions que nous avons présentées.
                </p>
              </div>

              <div className="bg-card border border-border rounded-lg p-6">
                <h3 className="text-xl font-bold mb-4">Puis-je créer du contenu ?</h3>
                <p className="text-muted-foreground">
                  Oui, les utilisateurs créent les contenus et enrichit le contenu du métaverse. Vous pouvez concevoir des 
                  objets, des espaces et des expériences, ou collaborer avec d'autres créateurs pour donner vie à 
                  d'audaces nouvelles et enrichissante expériences.
                </p>
              </div>
            </div>

            <div className="text-center mt-12">
              <h3 className="text-xl font-bold mb-4">Des questions supplémentaires ?</h3>
              <p className="text-muted-foreground mb-6">
                N'hésitez pas à nous contacter pour plus d'informations ou très 
                pour planifier une consultation.
              </p>
              <Button className="btn-tech">
                Nous contacter
              </Button>
            </div>
          </div>
        </section>
      </main>
      <Footer />
    </div>
  );
};

export default Salles3DImmersives;