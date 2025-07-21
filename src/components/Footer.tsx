import { Mail, Phone, MapPin, Facebook, Twitter, Instagram, Youtube } from 'lucide-react';
import { Button } from '@/components/ui/button';

const Footer = () => {
  const quickLinks = [
    { label: 'Accueil', href: '#accueil' },
    { label: 'Nos Hubs', href: '#hubs' },
    { label: 'Salles 3D', href: '#salles' },
    { label: 'Événements', href: '#evenements' }
  ];

  const supportLinks = [
    { label: 'Faire un Don', href: '#' },
    { label: 'Devenir Bénévole', href: '#' },
    { label: 'Partenariats', href: '#' },
    { label: 'Mentions Légales', href: '#' }
  ];

  const contactInfo = [
    {
      icon: MapPin,
      title: "Adresse",
      details: ["123 Avenue de la Innovation", "06000 Nice, France"]
    },
    {
      icon: Phone,
      title: "Téléphone",
      details: ["+33 4 XX XX XX XX"]
    },
    {
      icon: Mail,
      title: "Email",
      details: ["contact@gnut06.org", "info@gnut06.org"]
    }
  ];

  const socialLinks = [
    { icon: Facebook, href: "#", label: "Facebook" },
    { icon: Twitter, href: "#", label: "Twitter" },
    { icon: Instagram, href: "#", label: "Instagram" },
    { icon: Youtube, href: "#", label: "YouTube" }
  ];

  return (
    <footer id="contact" className="bg-background border-t border-border">
      {/* Main footer content */}
      <div className="section-container">
        <div className="grid lg:grid-cols-4 gap-12">
          {/* Logo and description */}
          <div className="lg:col-span-1">
            <h3 className="text-2xl font-bold text-gradient mb-4">GNUT06</h3>
            <p className="text-muted-foreground mb-6 leading-relaxed">
              Association dédiée à l'inclusion numérique à travers les nouvelles technologies. 
              Nous créons des opportunités pour tous dans le monde du numérique.
            </p>
            
            {/* Social links */}
            <div className="flex gap-3">
              {socialLinks.map((social, index) => (
                <Button
                  key={index}
                  variant="outline"
                  size="sm"
                  className="w-10 h-10 p-0 border-primary/30 hover:bg-primary hover:text-primary-foreground"
                  asChild
                >
                  <a href={social.href} target="_blank" rel="noopener noreferrer" aria-label={social.label}>
                    <social.icon className="h-4 w-4" />
                  </a>
                </Button>
              ))}
            </div>
          </div>

          {/* Quick links */}
          <div>
            <h4 className="font-semibold text-lg mb-6">Navigation</h4>
            <ul className="space-y-3">
              {quickLinks.map((link, index) => (
                <li key={index}>
                  <a 
                    href={link.href}
                    className="text-muted-foreground hover:text-primary transition-colors duration-300"
                  >
                    {link.label}
                  </a>
                </li>
              ))}
            </ul>
          </div>

          {/* Support links */}
          <div>
            <h4 className="font-semibold text-lg mb-6">Soutien</h4>
            <ul className="space-y-3">
              {supportLinks.map((link, index) => (
                <li key={index}>
                  <a 
                    href={link.href}
                    className="text-muted-foreground hover:text-primary transition-colors duration-300"
                  >
                    {link.label}
                  </a>
                </li>
              ))}
            </ul>
          </div>

          {/* Contact info */}
          <div>
            <h4 className="font-semibold text-lg mb-6">Contact</h4>
            <div className="space-y-4">
              {contactInfo.map((info, index) => (
                <div key={index} className="flex items-start gap-3">
                  <div className="flex-shrink-0 w-8 h-8 bg-primary/20 rounded-lg flex items-center justify-center mt-1">
                    <info.icon className="h-4 w-4 text-primary" />
                  </div>
                  <div>
                    <div className="font-medium text-sm mb-1">{info.title}</div>
                    {info.details.map((detail, idx) => (
                      <div key={idx} className="text-muted-foreground text-sm">
                        {detail}
                      </div>
                    ))}
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* Newsletter signup */}
        <div className="border-t border-border pt-12 mt-12">
          <div className="max-w-2xl mx-auto text-center">
            <h4 className="text-xl font-semibold mb-4">
              Restez Informé de nos <span className="text-gradient">Actualités</span>
            </h4>
            <p className="text-muted-foreground mb-6">
              Recevez nos dernières nouvelles, événements et opportunités directement dans votre boîte mail.
            </p>
            <div className="flex flex-col sm:flex-row gap-3 max-w-md mx-auto">
              <input 
                type="email" 
                placeholder="Votre adresse email"
                className="flex-1 px-4 py-3 bg-card border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary/50 focus:border-primary"
              />
              <Button className="btn-tech">
                S'abonner
              </Button>
            </div>
          </div>
        </div>
      </div>

      {/* Bottom footer */}
      <div className="border-t border-border bg-muted/30">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
          <div className="flex flex-col md:flex-row justify-between items-center gap-4">
            <div className="text-sm text-muted-foreground">
              © 2025 GNUT06. Tous droits réservés.
            </div>
            <div className="flex items-center gap-6 text-sm text-muted-foreground">
              <a href="#" className="hover:text-primary transition-colors">
                Politique de confidentialité
              </a>
              <a href="#" className="hover:text-primary transition-colors">
                Conditions d'utilisation
              </a>
              <a href="#" className="hover:text-primary transition-colors">
                Cookies
              </a>
            </div>
          </div>
        </div>
      </div>
    </footer>
  );
};

export default Footer;