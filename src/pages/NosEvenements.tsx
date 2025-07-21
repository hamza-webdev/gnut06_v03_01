import Header from '@/components/Header';
import Footer from '@/components/Footer';
import { Card, CardContent } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Calendar, MapPin, Users, Clock } from 'lucide-react';

const NosEvenements = () => {
  const events = [
    {
      title: "Séance de réalité virtuelle Loisirs Séjours Côte d'Azur (LSCA) du 13/06/25",
      description: "L'association Gnut 06, basée à Nice, œuvre pour l'inclusion des personnes en situation de handicap par le biais de technologies innovantes comme la réalité virtuelle et augmentée. Elle propose des ex...",
      date: "13/06/25",
      location: "PERMANENCE ST ROCH BUREAU 8",
      image: "https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=400&h=250&fit=crop"
    },
    {
      title: "PERMANENCE ST ROCH BUREAU 8 du 19/06/25",
      description: "L'association Gnut 06, basée à Nice, œuvre pour l'inclusion des personnes en situation de handicap par le biais de technologies innovantes comme la réalité virtuelle et augmentée. Elle propose des ex...",
      date: "19/06/25", 
      location: "PERMANENCE ST ROCH BUREAU 8",
      image: "https://images.unsplash.com/photo-1605810230434-7631ac76ec81?w=400&h=250&fit=crop"
    },
    {
      title: "PERMANENCE ST ROCH BUREAU 8 du 19/06/25",
      description: "L'association Gnut 06, basée à Nice, œuvre pour l'inclusion des personnes en situation de handicap par le biais de technologies innovantes comme la réalité virtuelle et augmentée. Elle propose des ex...",
      date: "19/06/25",
      location: "PERMANENCE ST ROCH BUREAU 8", 
      image: "https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=400&h=250&fit=crop"
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
                  <span className="text-gradient">Mondes Virtuels, Liens Réels :</span> L'Inclusion à Portée de main
                </h1>
                <p className="text-xl text-muted-foreground leading-relaxed">
                  Lorem ipsum dolor sit amet consectetur adipiscing elit. 
                  Quisque faucibus ex sapien vitae pellentesque sem placerat. 
                  In id cursus mi pretium tellus duis convallis. Tempus leo eu 
                  génésée sed diam urna tempor.
                </p>
              </div>
              <div className="relative">
                <div className="bg-gradient-to-br from-primary/20 to-purple-600/20 rounded-2xl p-8">
                  <img 
                    src="https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=500&h=400&fit=crop" 
                    alt="Réalité virtuelle et inclusion"
                    className="w-full h-64 object-cover rounded-lg"
                  />
                </div>
              </div>
            </div>
          </div>
        </section>

        {/* Call to Action */}
        <section className="py-16 bg-card/50">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
            <h2 className="text-3xl lg:text-4xl font-bold mb-8">
              Participez dès aujourd'hui à nos actions
            </h2>
          </div>
        </section>

        {/* Events Section */}
        <section className="py-20">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="grid md:grid-cols-3 gap-8">
              {events.map((event, index) => (
                <Card key={index} className="bg-card border-border hover:shadow-lg transition-shadow">
                  <CardContent className="p-0">
                    <img 
                      src={event.image}
                      alt={event.title}
                      className="w-full h-48 object-cover rounded-t-lg"
                    />
                    <div className="p-6">
                      <h3 className="text-lg font-bold mb-3 line-clamp-2">
                        {event.title}
                      </h3>
                      <p className="text-muted-foreground text-sm mb-4 line-clamp-3">
                        {event.description}
                      </p>
                      
                      <div className="space-y-2 mb-4">
                        <div className="flex items-center text-sm text-muted-foreground">
                          <Calendar className="w-4 h-4 mr-2" />
                          {event.date}
                        </div>
                        <div className="flex items-center text-sm text-muted-foreground">
                          <MapPin className="w-4 h-4 mr-2" />
                          {event.location}
                        </div>
                      </div>

                      <div className="flex justify-between items-center">
                        <span className="text-sm text-primary font-medium">
                          En savoir +
                        </span>
                        <Button size="sm" className="btn-tech">
                          Réserver
                        </Button>
                      </div>
                    </div>
                  </CardContent>
                </Card>
              ))}
            </div>

            {/* Pagination dots */}
            <div className="flex justify-center mt-12 space-x-2">
              <div className="w-3 h-3 bg-primary rounded-full"></div>
              <div className="w-3 h-3 bg-muted rounded-full"></div>
            </div>
          </div>
        </section>
      </main>
      <Footer />
    </div>
  );
};

export default NosEvenements;