import { useEffect, useState, useMemo } from 'react';
import { supabase } from '../lib/supabase';
import { Globe, Mail, MessageCircle, Loader2, FolderOpen } from 'lucide-react';
import { Link } from 'react-router-dom';

function Home() {
  const [projects, setProjects] = useState([]);
  const [clients, setClients] = useState([]);
  const [projectTypes, setProjectTypes] = useState([]);
  const [loading, setLoading] = useState(true);

  // Filtros
  const [filterYear, setFilterYear] = useState('all');
  const [filterType, setFilterType] = useState('all');
  const [filterClient, setFilterClient] = useState('all');

  useEffect(() => {
    async function fetchData() {
      try {
        setLoading(true);

        const { data: clientsData, error: clientsError } = await supabase.from('clients').select('*');
        if (clientsError) throw clientsError;

        const { data: typesData, error: typesError } = await supabase.from('project_types').select('*');
        if (typesError) throw typesError;

        const { data: projectsData, error: projectsError } = await supabase
          .from('projects')
          .select(`
            *,
            clients (*),
            project_types_mapping (
              project_types (*)
            )
          `)
          .order('year', { ascending: false });

        if (projectsError) throw projectsError;

        setClients(clientsData || []);
        setProjectTypes(typesData || []);
        
        const formattedProjects = (projectsData || []).map(p => ({
          ...p,
          categories: p.project_types_mapping?.map(m => m.project_types).filter(Boolean) || []
        }));

        setProjects(formattedProjects);

      } catch (error) {
        console.error("Error fetching data:", error);
      } finally {
        setLoading(false);
      }
    }

    fetchData();
  }, []);

  const years = useMemo(() => {
    const allYears = projects.map(p => p.year);
    return [...new Set(allYears)].sort((a, b) => b - a);
  }, [projects]);

  const filteredProjects = useMemo(() => {
    return projects.filter(project => {
      const matchYear = filterYear === 'all' || project.year.toString() === filterYear;
      const matchClient = filterClient === 'all' || project.client_id === filterClient;
      const matchType = filterType === 'all' || project.categories.some(c => c.id === filterType);
      
      return matchYear && matchClient && matchType;
    });
  }, [projects, filterYear, filterClient, filterType]);

  return (
    <div className="app-container container">
      {/* Navbar */}
      <nav className="navbar animate-fade-in delay-100">
        <div className="navbar-content glass">
          <div className="logo">Studio.</div>
          <div className="social-links">
            <a href="#" className="social-icon"><Globe size={20} /></a>
            <a href="#" className="social-icon"><MessageCircle size={20} /></a>
            <a href="#" className="social-icon"><Mail size={20} /></a>
          </div>
        </div>
      </nav>

      {/* Header */}
      <header className="header-section animate-fade-in delay-200">
        <h1 className="header-title">Diseño Visual & Experiencias Digitales</h1>
        <p className="header-subtitle">Explora mi portfolio de proyectos seleccionados.</p>
      </header>

      {/* Filter Bar */}
      <section className="filter-bar glass animate-fade-in delay-300">
        <div className="filter-group">
          <label className="filter-label" htmlFor="yearFilter">Año</label>
          <select 
            id="yearFilter" 
            className="filter-select" 
            value={filterYear} 
            onChange={(e) => setFilterYear(e.target.value)}
          >
            <option value="all">Todos los años</option>
            {years.map(year => (
              <option key={year} value={year}>{year}</option>
            ))}
          </select>
        </div>

        <div className="filter-group">
          <label className="filter-label" htmlFor="typeFilter">Categoría</label>
          <select 
            id="typeFilter" 
            className="filter-select" 
            value={filterType} 
            onChange={(e) => setFilterType(e.target.value)}
          >
            <option value="all">Todas las categorías</option>
            {projectTypes.map(type => (
              <option key={type.id} value={type.id}>{type.name}</option>
            ))}
          </select>
        </div>

        <div className="filter-group">
          <label className="filter-label" htmlFor="clientFilter">Cliente</label>
          <select 
            id="clientFilter" 
            className="filter-select" 
            value={filterClient} 
            onChange={(e) => setFilterClient(e.target.value)}
          >
            <option value="all">Todos los clientes</option>
            {clients.map(client => (
              <option key={client.id} value={client.id}>{client.name}</option>
            ))}
          </select>
        </div>
      </section>

      {/* Main Content */}
      <main>
        {loading ? (
          <div className="loading-container">
            <Loader2 className="spinner" size={48} />
            <p>Cargando proyectos espectaculares...</p>
          </div>
        ) : (
          <div className="projects-grid animate-fade-in delay-300">
            {filteredProjects.length > 0 ? (
              filteredProjects.map(project => (
                <Link to={`/project/${encodeURIComponent(project.title)}`} key={project.id}>
                  <article className="project-card glass">
                    <div className="project-image-container">
                      <img 
                        src={project.image_url || `https://picsum.photos/seed/${project.id}/800/600`} 
                        alt={project.title} 
                        className="project-image"
                        loading="lazy"
                      />
                      <div className="project-tags">
                        {project.categories.slice(0, 2).map(cat => (
                          <span key={cat.id} className="project-tag">{cat.name}</span>
                        ))}
                        {project.categories.length > 2 && (
                          <span className="project-tag">+{project.categories.length - 2}</span>
                        )}
                      </div>
                    </div>
                    <div className="project-content">
                      <h2 className="project-title">{project.title}</h2>
                      <p className="project-description">{project.description}</p>
                      <div className="project-meta">
                        {project.clients && (
                          <div className="project-client">
                            {project.clients.logo_url && (
                              <img src={project.clients.logo_url} alt={project.clients.name} className="client-avatar" />
                            )}
                            <span>{project.clients.name}</span>
                          </div>
                        )}
                        <span className="project-year">{project.year}</span>
                      </div>
                    </div>
                  </article>
                </Link>
              ))
            ) : (
              <div className="empty-state">
                <FolderOpen size={48} className="empty-icon" />
                <h3>No hay proyectos que coincidan</h3>
                <p>Prueba a cambiar los filtros para ver más resultados.</p>
              </div>
            )}
          </div>
        )}
      </main>
    </div>
  );
}

export default Home;
