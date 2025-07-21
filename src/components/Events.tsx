import { Calendar, MapPin, Clock, Users } from 'lucide-react';
import { Button } from '@/components/ui/button';

const Events = () => {
  const upcomingEvents = [
    {
      title: "Formation VR pour Débutants",
      date: "25 Janvier 2025",
      time: "14:00 - 17:00",
      location: "Hub Gaming GNUT",
      attendees: 12,
      maxAttendees: 15,
      type: "Formation",
      description: "Découvrez les bases de la réalité virtuelle dans un environnement bienveillant."
    },
    {
      title: "Hackathon Innovation 3D",
      date: "2 Février 2025", 
      time: "09:00 - 18:00",
      location: "Salle 3D Principale",
      attendees: 24,
      maxAttendees: 30,
      type: "Compétition",
      description: "48h pour créer des solutions innovantes en utilisant nos technologies 3D."
    },
    {
      title: "Soirée Métaverse Communautaire",
      date: "15 Février 2025",
      time: "19:00 - 22:00", 
      location: "Hub Métaverse",
      attendees: 8,
      maxAttendees: 20,
      type: "Social",
      description: "Rencontrez la communauté GNUT06 dans nos espaces virtuels."
    }
  ];

  const getTypeColor = (type: string) => {
    switch (type) {
      case 'Formation': return 'bg-primary/20 text-primary border-primary/30';
      case 'Compétition': return 'bg-accent/20 text-accent border-accent/30';
      case 'Social': return 'bg-secondary/20 text-secondary border-secondary/30';
      default: return 'bg-muted/20 text-muted-foreground border-muted/30';
    }
  };

  return (
    <section id="evenements" className="section-container bg-muted/30">
      <div className="text-center mb-16">
        <h2 className="text-4xl md:text-5xl font-bold mb-6">
          <span className="text-gradient">Événements</span>
        </h2>
        <p className="text-lg text-muted-foreground max-w-3xl mx-auto">
          Rejoignez notre communauté lors d'événements passionnants qui mêlent technologie, 
          créativité et innovation collaborative.
        </p>
      </div>

      <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
        {upcomingEvents.map((event, index) => (
          <div key={index} className="card-tech">
            {/* Event type badge */}
            <div className="flex justify-between items-start mb-4">
              <span className={`px-3 py-1 rounded-full text-xs font-medium border ${getTypeColor(event.type)}`}>
                {event.type}
              </span>
              <div className="text-right text-sm text-muted-foreground">
                <div className="flex items-center gap-1">
                  <Users className="h-4 w-4" />
                  {event.attendees}/{event.maxAttendees}
                </div>
              </div>
            </div>

            {/* Event title */}
            <h3 className="text-xl font-bold mb-3">{event.title}</h3>
            <p className="text-muted-foreground text-sm mb-4">{event.description}</p>

            {/* Event details */}
            <div className="space-y-3 mb-6">
              <div className="flex items-center gap-3 text-sm">
                <Calendar className="h-4 w-4 text-primary" />
                <span>{event.date}</span>
              </div>
              <div className="flex items-center gap-3 text-sm">
                <Clock className="h-4 w-4 text-primary" />
                <span>{event.time}</span>
              </div>
              <div className="flex items-center gap-3 text-sm">
                <MapPin className="h-4 w-4 text-primary" />
                <span>{event.location}</span>
              </div>
            </div>

            {/* Progress bar */}
            <div className="mb-4">
              <div className="flex justify-between text-xs text-muted-foreground mb-2">
                <span>Places réservées</span>
                <span>{Math.round((event.attendees / event.maxAttendees) * 100)}%</span>
              </div>
              <div className="w-full bg-muted rounded-full h-2">
                <div 
                  className="bg-gradient-to-r from-primary to-secondary h-2 rounded-full transition-all duration-300"
                  style={{ width: `${(event.attendees / event.maxAttendees) * 100}%` }}
                />
              </div>
            </div>

            {/* CTA Button */}
            <Button 
              className="w-full btn-tech"
              disabled={event.attendees >= event.maxAttendees}
            >
              {event.attendees >= event.maxAttendees ? 'Complet' : 'S\'inscrire'}
            </Button>
          </div>
        ))}
      </div>

      {/* View all events */}
      <div className="text-center mt-12">
        <Button className="btn-tech-outline">
          Voir Tous les Événements
        </Button>
      </div>
    </section>
  );
};

export default Events;