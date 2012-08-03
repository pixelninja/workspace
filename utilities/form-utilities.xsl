<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:import href='form-controls.xsl' />

<!--
	Form Fields Built From Section Schema
-->
	<xsl:template match="*" mode="field">
		<xsl:param name="placeholder" />
		<xsl:param name="event" />
		<xsl:variable name="field" select="local-name()" />

		<xsl:choose>
			<xsl:when test="@type='textbox' and (text-size='medium' or text-size='small')">
				<div class="field textarea">
					<label>
						<span>
							<xsl:value-of select="@label" />
							<xsl:if test="@required = 'yes'">
								<em> *</em>
							</xsl:if>
						</span>
						
						<xsl:call-template name="create-textarea">
							<xsl:with-param name="event" select="$event" />
							<xsl:with-param name="field">
								<textarea rows="5" name="{concat('fields[',$field,']')}">
									<xsl:if test="@required='yes'">
										<xsl:attribute name="class">
											<xsl:text>required</xsl:text>
										</xsl:attribute>
									</xsl:if>

									<xsl:value-of select="$event//*[name() = $field]" />
								</textarea>
							</xsl:with-param>
						</xsl:call-template>

						<xsl:call-template name="create-error">
							<xsl:with-param name="status" select="$event//*[name() = $field]" />
						</xsl:call-template>
					</label>
				</div>
			</xsl:when>
			<xsl:when test="@type='textbox'">
				<div id="{$field}" class="field">
					<label>

						<!--
							Customise labels for certain fields
						-->
						<span class="{$field}">
							<xsl:choose>
								<xsl:when test="$field = 'office-address-line-1'">
									<xsl:text>Office Address</xsl:text>
								</xsl:when>
								<xsl:when test="$field = 'postal-address-line-1'">
									<xsl:text>Postal Address</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="@label" />
								</xsl:otherwise>

							</xsl:choose>

							<xsl:if test="@required = 'yes'">
								<em> *</em>
							</xsl:if>
						</span>

						<xsl:call-template name="create-input">
							<xsl:with-param name="event" select="$event" />
							<xsl:with-param name="field">
								<input class="textfield" name="{concat('fields[',$field,']')}">
									<xsl:choose>
										<xsl:when test="@required='yes' and ($field='email' or $field='email-address')">
											<xsl:attribute name="class">
												<xsl:text>textfield required email</xsl:text>
											</xsl:attribute>
										</xsl:when>
										<xsl:when test="$field='fax' or $field='phone'">
											<xsl:attribute name="class">
												<xsl:text>textfield number</xsl:text>
											</xsl:attribute>
										</xsl:when>
										<xsl:when test="$field='office-postcode' or $field='postal-postcode'">
											<xsl:attribute name="class">
												<xsl:text>textfield required postcode number</xsl:text>
											</xsl:attribute>
										</xsl:when>
										<xsl:when test="@required='yes'">
											<xsl:attribute name="class">
												<xsl:text>textfield required</xsl:text>
											</xsl:attribute>
										</xsl:when>
									</xsl:choose>

									<xsl:attribute name="value">
										<xsl:value-of select="$event//*[name() = $field]" />
									</xsl:attribute>
									
									<xsl:if test="$placeholder = 'true'">
										<xsl:attribute name="placeholder">
											<xsl:value-of select="@label" />
										</xsl:attribute>
									</xsl:if>
								</input>
							</xsl:with-param>
						</xsl:call-template>

						<xsl:call-template name="create-error">
							<xsl:with-param name="status" select="$event//*[name() = $field]" />
						</xsl:call-template>
					</label>
				</div>
			</xsl:when>
			<xsl:when test="@type='datetime' and name() != 'submitted'">
				<div class="field">
					<label>
						<xsl:value-of select="@label" />
						<xsl:if test="@required = 'yes'">
							<em> *</em>
						</xsl:if>

						<xsl:call-template name="create-input">
							<xsl:with-param name="event" select="$event" />
							<xsl:with-param name="field">
								<input name="{concat('fields[',$field,']')}" class="textfield">
									<xsl:attribute name="value">
										<xsl:value-of select="$event//*[name() = $field]" />
									</xsl:attribute>
								</input>
							</xsl:with-param>
						</xsl:call-template>

						<xsl:call-template name="create-error">
							<xsl:with-param name="status" select="$event//*[name() = $field]" />
						</xsl:call-template>
					</label>
				</div>
			</xsl:when>
			<xsl:when test="@type='select' and allow-multiple-selection = 'yes'">
				<div class="field checkbox">
					<xsl:for-each select="options/option">
						<label>
							<xsl:call-template name="create-checkbox">
								<xsl:with-param name="event" select="$event" />
								<xsl:with-param name="field">
									<input name="{concat('fields[',$field,'][]')}" value="{@value}" type="checkbox">
										<xsl:if test="$event//*[name() = $field]/item = @value">
											<xsl:attribute name="checked">
												<xsl:text>checked</xsl:text>
											</xsl:attribute>
										</xsl:if>
									</input>
								</xsl:with-param>
							</xsl:call-template>

							<xsl:value-of select="@value" />
						</label>
					</xsl:for-each>
				</div>
			</xsl:when>
			<xsl:when test="@type='select'">
				<div class="field select">
					<label>
						<span class="{$field}">	
							<xsl:value-of select="@label" />
							
							<xsl:if test="@required = 'yes'">
								<em> *</em>
							</xsl:if>
						</span>
						<xsl:call-template name="create-select">
							<xsl:with-param name="event" select="$event" />
							<xsl:with-param name="field">
								<select name="{concat('fields[',$field,']')}">
									<option value="">Please select&#8230;</option>
									<xsl:for-each select="options/option">
										<option value="{@value}">
											<xsl:if test="$event//*[name() = $field] = @value">
												<xsl:attribute name="selected">
													<xsl:text>selected</xsl:text>
												</xsl:attribute>
											</xsl:if>
											<xsl:value-of select="@value" />
										</option>
									</xsl:for-each>
								</select>
							</xsl:with-param>
						</xsl:call-template>

						<xsl:call-template name="create-error">
							<xsl:with-param name="status" select="$event//*[name() = $field]" />
						</xsl:call-template>
					</label>
				</div>
			</xsl:when>
			<xsl:when test="@type='checkbox'">
				<div class="field select">
					<label>
						<span class="{$field}">
							<xsl:value-of select="description" />
							
							<xsl:if test="@required = 'yes'">
								<em> *</em>
							</xsl:if>
						</span>

						<xsl:call-template name="create-select">
							<xsl:with-param name="event" select="$event" />
							<xsl:with-param name="field">
								<select class="required" name="{concat('fields[',$field,']')}">
									<option value="">Please select ...</option>
									<option>Yes</option>
									<option>No</option>
								</select>
							</xsl:with-param>
						</xsl:call-template>

						<xsl:call-template name="create-error">
							<xsl:with-param name="status" select="$event//*[name() = $field]" />
						</xsl:call-template>
					</label>
				</div>
			</xsl:when>
			<xsl:when test="@type='uniqueupload' or @type='upload'">
				<div class="field upload">
					<label>
						<span class="{$field}">
							<xsl:value-of select="@label" />
							
							<xsl:if test="@required = 'yes'">
								<em> *</em>
							</xsl:if>
						</span>

						<xsl:call-template name="create-upload">
							<xsl:with-param name="event" select="$event" />
							<xsl:with-param name="field">
								<input name="{concat('fields[',$field,']')}" type='file'>
									<xsl:if test="@required = 'yes'">
										<xsl:attribute name='class'>required</xsl:attribute>
									</xsl:if>
								</input>
							</xsl:with-param>
						</xsl:call-template>

						<xsl:call-template name="create-error">
							<xsl:with-param name="status" select="$event//*[name() = $field]" />
						</xsl:call-template>
					</label>
				</div>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>