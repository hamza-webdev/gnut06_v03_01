import { Linkedin, Github, Mail } from 'lucide-react';
import { Button } from '@/components/ui/button';

const Team = () => {
  const teamMembers = [
    {
      name: "Dr. Marie Dubois",
      role: "Directrice Innovation",
      description: "Spécialiste en réalité virtuelle et inclusion numérique depuis 10 ans",
      avatar: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop&crop=face",
      social: {
        linkedin: "#",
        github: "#",
        email: "marie.dubois@gnut06.org"
      }
    },
    {
      name: "Thomas Chen",
      role: "Lead Développeur VR",
      description: "Expert en développement d'applications immersives et métaverse",
      avatar: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop&crop=face",
      social: {
        linkedin: "#",
        github: "#", 
        email: "thomas.chen@gnut06.org"
      }
    },
    {
      name: "Sophie Laurent",
      role: "Responsable Pédagogique",
      description: "Ancienne enseignante passionnée par l'éducation technologique",
      avatar: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400&h=400&fit=crop&crop=face",
      social: {
        linkedin: "#",
        github: "#",
        email: "sophie.laurent@gnut06.org"
      }
    },
    {
      name: "Alex Moreau",
      role: "Community Manager",
      description: "Créateur de liens et organisateur d'événements tech communautaires",
      avatar: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&h=400&fit=crop&crop=face",
      social: {
        linkedin: "#",
        github: "#",
        email: "alex.moreau@gnut06.org"
      }
    }
  ];

  return (
    <section id="equipe" className="section-container bg-muted/30">
      <div className="text-center mb-16">
        <h2 className="text-4xl md:text-5xl font-bold mb-6">
          Notre <span className="text-gradient">Gnut Team</span>
        </h2>
        <p className="text-lg text-muted-foreground max-w-3xl mx-auto">
          Une équipe passionnée et experte qui œuvre chaque jour pour rendre 
          la technologie accessible à tous et créer des expériences exceptionnelles.
        </p>
      </div>

      <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-8">
        {teamMembers.map((member, index) => (
          <div key={index} className="card-tech text-center group">
            {/* Avatar */}
            <div className="relative mb-6">
              <div className="w-32 h-32 mx-auto rounded-full overflow-hidden border-4 border-primary/20 group-hover:border-primary/50 transition-all duration-300">
                <img 
                  src={member.avatar} 
                  alt={member.name}
                  className="w-full h-full object-cover group-hover:scale-110 transition-transform duration-300"
                />
              </div>
              {/* Gradient overlay on hover */}
              <div className="absolute inset-0 w-32 h-32 mx-auto rounded-full bg-gradient-to-t from-primary/20 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300" />
            </div>

            {/* Info */}
            <div className="mb-6">
              <h3 className="text-xl font-bold mb-2">{member.name}</h3>
              <div className="inline-block px-3 py-1 bg-primary/20 text-primary text-sm rounded-full mb-3">
                {member.role}
              </div>
              <p className="text-muted-foreground text-sm leading-relaxed">
                {member.description}
              </p>
            </div>

            {/* Social links */}
            <div className="flex justify-center gap-3">
              <Button 
                variant="outline" 
                size="sm" 
                className="w-10 h-10 p-0 border-primary/30 hover:bg-primary hover:text-primary-foreground"
                asChild
              >
                <a href={member.social.linkedin} target="_blank" rel="noopener noreferrer">
                  <Linkedin className="h-4 w-4" />
                </a>
              </Button>
              <Button 
                variant="outline" 
                size="sm" 
                className="w-10 h-10 p-0 border-primary/30 hover:bg-primary hover:text-primary-foreground"
                asChild
              >
                <a href={member.social.github} target="_blank" rel="noopener noreferrer">
                  <Github className="h-4 w-4" />
                </a>
              </Button>
              <Button 
                variant="outline" 
                size="sm" 
                className="w-10 h-10 p-0 border-primary/30 hover:bg-primary hover:text-primary-foreground"
                asChild
              >
                <a href={`mailto:${member.social.email}`}>
                  <Mail className="h-4 w-4" />
                </a>
              </Button>
            </div>
          </div>
        ))}
      </div>

      {/* Join team CTA */}
      <div className="text-center mt-16">
        <div className="max-w-2xl mx-auto p-8 bg-gradient-to-r from-card/50 to-muted/50 rounded-2xl border border-border/50">
          <h3 className="text-2xl font-bold mb-4">
            Rejoignez notre équipe !
          </h3>
          <p className="text-muted-foreground mb-6">
            Nous recherchons des talents passionnés pour développer l'avenir de l'inclusion numérique.
          </p>
          <Button className="btn-tech">
            Voir les Postes Ouverts
          </Button>
        </div>
      </div>
    </section>
  );
};

export default Team;