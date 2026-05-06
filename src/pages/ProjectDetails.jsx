import { useEffect, useState } from 'react';
import { useParams, Link, useNavigate } from 'react-router-dom';
import { supabase } from '../lib/supabase';
import { ArrowLeft, Loader2, Calendar, Tag, User } from 'lucide-react';

function ProjectDetails() {
  const { title } = useParams();
  const navigate = useNavigate();
  const [project, setProject] = useState(null);
  const [relatedProjects, setRelatedProjects] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function fetchProjectData() {
      try {
        setLoading(true);
        // Fetch current project
        const { data: projectData, error: projectError } = await supabase
          .from('projects')
          .select(`
            *,
            clients (*),
            project_types_mapping (
              project_types (*)
            )
          `)
          .eq('title', decodeURIComponent(title))
          .single();

        if (projectError) throw projectError;

        const formattedProject = {
          ...projectData,
          categories: projectData.project_types_mapping?.map(m => m.project_types).filter(Boolean) || []
        };
        
        setProject(formattedProject);

        // Fetch related projects (same categories, excluding current)
        if (formattedProject.categories.length > 0) {
          const categoryIds = formattedProject.categories.map(c => c.id);
          
          // First, get all mappings for these categories
          const { data: mappings } = await supabase
            .from('project_types_mapping')
            .select('project_id')
            .in('project_type_id', categoryIds)
            .neq('project_id', projectData.id);

          if (mappings && mappings.length > 0) {
            const relatedProjectIds = [...new Set(mappings.map(m => m.project_id))];
            
            // Then fetch those specific projects
            const { data: relatedData } = await supabase
              .from('projects')
              .select(`
                *,
                clients (*),
                project_types_mapping (
                  project_types (*)
                )
              `)
              .in('id', relatedProjectIds)
              .limit(3);
              
            if (relatedData) {
              const formattedRelated = relatedData.map(p => ({
                ...p,
                categories: p.project_types_mapping?.map(m => m.project_types).filter(Boolean) || []
              }));
              setRelatedProjects(formattedRelated);
            }
          }
        }
      } catch (error) {
        console.error("Error fetching project details:", error);
      } finally {
        setLoading(false);
      }
    }

    fetchProjectData();
    window.scrollTo(0, 0);
  }, [title]);

  if (loading) {
    return (
      <div className="loading-container">
        <Loader2 className="spinner" size={48} />
        <p>Cargando detalles del proyecto...</p>
      </div>
    );
  }

  if (!project) {
    return (
      <div className="container" style={{ padding: '4rem 2rem', textAlign: 'center' }}>
        <h2>Proyecto no encontrado</h2>
        <button onClick={() => navigate('/')} className="back-btn glass" style={{ marginTop: '2rem' }}>
          Volver al inicio
        </button>
      </div>
    );
  }

  return (
    <div className="project-detail-container container animate-fade-in">
      <nav className="detail-nav">
        <button onClick={() => navigate('/')} className="back-btn glass">
          <ArrowLeft size={20} />
          <span>Volver al inicio</span>
        </button>
      </nav>

      <article className="detail-hero glass">
        <div className="detail-image-wrapper">
          <img 
            src={project.image_url || `https://picsum.photos/seed/${project.id}/1200/800`} 
            alt={project.title} 
            className="detail-hero-image"
          />
        </div>
        
        <div className="detail-content">
          <h1 className="detail-title">{project.title}</h1>
          
          <div className="detail-metadata">
            {project.clients && (
              <div className="meta-item glass">
                <User size={18} className="meta-icon" />
                <div className="meta-info">
                  <span className="meta-label">Cliente</span>
                  <span className="meta-value">{project.clients.name}</span>
                </div>
              </div>
            )}
            
            <div className="meta-item glass">
              <Calendar size={18} className="meta-icon" />
              <div className="meta-info">
                <span className="meta-label">Año</span>
                <span className="meta-value">{project.year}</span>
              </div>
            </div>

            <div className="meta-item glass">
              <Tag size={18} className="meta-icon" />
              <div className="meta-info">
                <span className="meta-label">Categorías</span>
                <div className="meta-tags">
                  {project.categories.map(cat => (
                    <span key={cat.id} className="meta-tag-small">{cat.name}</span>
                  ))}
                </div>
              </div>
            </div>
          </div>

          <div className="detail-description glass">
            <h3>Acerca del proyecto</h3>
            <p>{project.description}</p>
          </div>
        </div>
      </article>

      {relatedProjects.length > 0 && (
        <section className="related-projects animate-fade-in delay-200">
          <h2 className="related-title">Proyectos Similares</h2>
          <div className="projects-grid">
            {relatedProjects.map(related => (
              <Link to={`/project/${encodeURIComponent(related.title)}`} key={related.id}>
                <article className="project-card glass">
                  <div className="project-image-container">
                    <img 
                      src={related.image_url || `https://picsum.photos/seed/${related.id}/800/600`} 
                      alt={related.title} 
                      className="project-image"
                      loading="lazy"
                    />
                  </div>
                  <div className="project-content">
                    <h3 className="project-title" style={{fontSize: '1.1rem'}}>{related.title}</h3>
                    <div className="project-meta">
                      <span className="project-year">{related.year}</span>
                    </div>
                  </div>
                </article>
              </Link>
            ))}
          </div>
        </section>
      )}
    </div>
  );
}

export default ProjectDetails;
