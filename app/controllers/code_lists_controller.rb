class CodeListsController < BasicInstrumentController
  # Initialise finding object for item based actions
  only_set_object

  # Set model for automatic CRUD actions
  @model_class = CodeList

  # List of params that can be set and edited
  @params_list = [:label, :min_responses, :max_responses, codes_attributes: [ :id, :value, :order, :category_id, :_destroy, category_attributes: [:id, :label, :instrument_id] ]]

  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: e.record.errors.full_messages.to_sentence, status: :unprocessable_entity
  end

  # POST /instruments/1/code_lists.json
  def create
    @object = collection.new(safe_params)

    if @object.save
      if params.has_key? :codes
        @object.update_codes(params[:codes])
      end
      if params.has_key?(:rd) && params[:rd]
        @object.response_domain = true
      else
        @object.response_domain = false
      end
      render :show, status: :created
    else
      render json: { errors: @object.errors, error_sentence: @object.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /instruments/1/code_lists/1.json
  def update
    parameters = safe_params

    if params.has_key? :rd
      if params[:rd]
        @object.response_domain = true
        @object.response_domain.min_responses = params[:min_responses]
        @object.response_domain.max_responses = params[:max_responses]
        @object.response_domain.save!
      else
        @object.response_domain = false
      end
    end
    if @object.update_attributes(parameters)
      respond_to do |format|
        format.json { render :show, status: :ok }
      end
    else
      respond_to do |format|
        format.json { render json: { errors: @object.errors, error_sentence: @object.errors.full_messages.to_sentence }, status: :unprocessable_entity }
      end
    end
  end

  private

  def safe_params
    # The params from Angular use :codes in the params array, we
    # tranform these into params that comply with the params expected
    # by nested attributes using accepts_nested_attributes for the codes
    # and their nested categories.

    # Codes might be a wrapped parameter or not, for example it is not in the
    # controller test
    codes_params = params.delete(:codes) || params[:code_list].try(:delete, :codes)
    if codes_params
      codes_params = codes_params.map do | code |
        category_label = code.delete(:label)
        category = @instrument.categories.where(label: category_label).first
        if category
          # Assign to existing category
          code[:category_id] = category.id
        else
          code.delete(:category_id)
          # Create new category
          code[:category_attributes] = {
            label: category_label,
            instrument_id: @instrument.id
          }
        end
        code
      end
      if @object
        existing_codes = @object.codes.map(&:id)
        codes_to_delete = existing_codes - codes_params.map{|cp|cp[:id]}
        codes_params.concat(codes_to_delete.map{|id| { id: id, _destroy: true}})
      end
      params[:code_list][:codes_attributes] = codes_params
    end
    super
  end

end
